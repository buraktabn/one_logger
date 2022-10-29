import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:one_logger/src/helper.dart';
import 'package:one_logger/src/loki/options.dart';
import 'package:tuple/tuple.dart';

import '../logger.dart';

void pushIsolate(Tuple2<SendPort, LokiOptions> payload) {
  final receivePort = ReceivePort();
  payload.item1.send(receivePort.sendPort);
  final lokiOptions = payload.item2;
  final jobs = <PushPayload>[];

  if (lokiOptions.batchEvery != null) {
    Timer.periodic(lokiOptions.batchEvery!, (_) async {
      final mJobs = [...jobs];
      await _pushBatch(lokiOptions.lokiUrl, mJobs);
      for (final r in mJobs) {
        jobs.remove(r);
      }
    });
  }
  receivePort.listen((val) async {
    if (val == 'exit') {
      do {
        await Future.delayed(const Duration(milliseconds: 100));
      } while (jobs.isNotEmpty);
      Isolate.exit();
    }
    try {
      final msg = val as Tuple3<List<String>, String, LokiLabel?>;
      final pushPayload =
          PushPayload(streams: {'service': msg.item2, ...?msg.item3}, logs: msg.item1);
      jobs.add(pushPayload);
      if (lokiOptions.batchEvery != null) {
        return;
      }
      await _push(lokiOptions.lokiUrl, pushPayload);
      jobs.remove(pushPayload);
    } catch (_) {
      // --jobs;
    }
  });
}

final dio = Dio(BaseOptions(
  headers: {'Content-Type': 'application/json'},
));

Future<void> _push(String lokiUrl, PushPayload payload) async {
  await send(lokiUrl, payload.toMap());
}

Future<void> _pushBatch(String lokiUrl, List<PushPayload> payloads) async {
  final data = {"streams": <Map<String, dynamic>>[]};
  data['streams'] = payloads.map((e) => e.toSingleMap()).toList();
  await send(lokiUrl, data);
}

Future<void> send(String lokiUrl, Map<String, dynamic> data) async {
  try {
    final res = await dio.post(lokiUrl, data: data);
    if (res.statusCode != 204) {
      throw Exception(res.data);
    }
  } on DioError catch (err, st) {
    Logger().error(err, stackTrace: st, module: 'loki-push');
  } catch (error, st) {
    Logger().error(error, stackTrace: st, module: 'loki-push');
    rethrow;
  }
}

class PushPayload extends Equatable {
  const PushPayload({required this.streams, required this.logs});

  final Map<String, String> streams;
  final List<String> logs;

  Map<String, dynamic> toMap() {
    return {
      "streams": [
        {"stream": streams, "values": _getValues()}
      ]
    };
  }

  Map<String, dynamic> toSingleMap() {
    return {"stream": streams, "values": _getValues()};
  }

  List<List<String>> _getValues() {
    final values = <List<String>>[];
    for (final log in logs) {
      final split = log.split(']');
      final date = dateFormat.parse(split.first.split('[').last).toUtc().millisecondsSinceEpoch;
      values.add(["${date}000000", split.sublist(1).join(']').trim()]);
    }
    return values;
  }

  @override
  List<Object?> get props => [streams, logs];

  @override
  bool? get stringify => true;
}

import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:one_logger/src/helper.dart';
import 'package:tuple/tuple.dart';

import '../logger.dart';

void pushIsolate(Tuple2<SendPort, String> payload) {
  final receivePort = ReceivePort();
  payload.item1.send(receivePort.sendPort);
  int jobs = 0;
  receivePort.listen((val) async {
    if (val == 'exit') {
      do {
        if (jobs == 0) {
          Isolate.exit();
        }

        await Future.delayed(const Duration(milliseconds: 100));
      } while (jobs != 0);
    }
    try {
      ++jobs;
      final msg = val as Tuple3<List<String>, String, LokiLabel?>;
      final pushPayload = PushPayload(streams: {'service': msg.item2, ...?msg.item3}, logs: msg.item1);
      await _push(payload.item2, pushPayload);
      --jobs;
    } catch (_) {
      // --jobs;
    }
  });
}

final dio = Dio(BaseOptions(
  headers: {'Content-Type': 'application/json'},
));

Future<void> _push(String lokiUrl, PushPayload payload) async {
  try {
    final res = await dio.post(lokiUrl, data: payload.toMap());
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

class PushPayload {
  const PushPayload({required this.streams, required this.logs});

  final Map<String, String> streams;
  final List<String> logs;

  Map<String, dynamic> toMap() {
    final values = <List<String>>[];
    for (final log in logs) {
      final split = log.split(']');
      final date = dateFormat.parse(split.first.split('[').last).toUtc().millisecondsSinceEpoch;
      values.add(["${date}000000", split.sublist(1).join(']').trim()]);
    }

    return {
      "streams": [
        {"stream": streams, "values": values}
      ]
    };
  }
}

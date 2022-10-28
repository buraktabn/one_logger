import 'dart:io';
import 'dart:isolate';

import 'package:one_logger/src/loki/pusher.dart';
import 'package:tuple/tuple.dart';

import 'helper.dart';
import 'options/options.dart';

late final SendPort _sendPort;

class Logger {
  const Logger({this.module, this.lokiUrl, this.options = defaultLevelOptions});

  final String? module;
  final String? lokiUrl;
  final LoggerOptions options;

  bool get lokiEnabled => lokiUrl != null;
  String get _loggerModuleName {
    if (module == null) {
      return 'logger';
    }
    return '$module:logger';
  }

  void info(msg, [String? module]) => _print(msg, Level.info, module);

  void warn(msg, [String? module]) => _print(msg, Level.warn, module);

  void error(msg, [StackTrace? stackTrace, String? module]) =>
      _print('$msg${stackTrace == null ? '' : '\n$stackTrace'}', Level.error, module);

  void debug(msg, [String? module]) => _print(msg, Level.debug, module);

  void _print(msg, Level level, [String? module]) {
    final log = ansiPrint(msg, level: level, module: module ?? this.module, options: options);
    if (lokiEnabled) {
      final val = Tuple2([log], module ?? this.module ?? Platform.localHostname);
      try {
        _sendPort.send(val);
      } catch (_) {
        warn('Loki is not yet active or disposed.', _loggerModuleName);
        warn('Trying to restart it', _loggerModuleName);
        try {
          startLoki().then((_) => _sendPort.send(val));
        } catch (_) {
          error('Loki retry failed. This should be reported', null, _loggerModuleName);
        }
      }
    }
  }

  Future<void> startLoki() async {
    if (!lokiEnabled) {
      warn('Loki URL not configured');
      return;
    }
    final receiverPort = ReceivePort();
    final isolate = await Isolate.spawn(pushIsolate, Tuple2(receiverPort.sendPort, lokiUrl!),
        debugName: 'Grafana Loki Pusher');

    try {
      _sendPort = await receiverPort.first;
    } catch(_) {
      isolate.kill();
    }
  }

  void disposeLoki() {
    _sendPort.send('exit');
  }

  Logger copyWith({String? module, LoggerOptions? options}) =>
      Logger(module: module ?? this.module, options: options ?? this.options);
}

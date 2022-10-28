import 'dart:io';
import 'dart:isolate';

import 'package:one_logger/src/loki/pusher.dart';
import 'package:tuple/tuple.dart';

import 'helper.dart';
import 'options/options.dart';

typedef LokiLabel = Map<String, String>;

const _level = 'level';

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

  void info(msg, {String? module, LokiLabel? labels}) =>
      _print(msg, Level.info, module, {_level: Level.info.toString(), ...?labels});

  void warn(msg, {String? module, LokiLabel? labels}) =>
      _print(msg, Level.warn, module, {_level: Level.warn.toString(), ...?labels});

  void error(msg, {StackTrace? stackTrace, String? module, LokiLabel? labels}) => _print(
      '$msg${stackTrace == null ? '' : '\n$stackTrace'}',
      Level.error,
      module,
      {_level: Level.error.toString(), ...?labels});

  void debug(msg, {String? module, LokiLabel? labels}) =>
      _print(msg, Level.debug, module, {_level: Level.debug.toString(), ...?labels});

  void _print(msg, Level level, [String? module, LokiLabel? labels]) {
    final log = ansiPrint(msg, level: level, module: module ?? this.module, options: options);
    if (lokiEnabled) {
      final val = Tuple3([log], module ?? this.module ?? Platform.localHostname, labels);
      try {
        _sendPort.send(val);
      } catch (_) {
        final logger = copyWith(module: _loggerModuleName);
        logger.warn('Loki is not yet active or disposed.');
        logger.warn('Trying to restart it');
        try {
          startLoki().then((_) => _sendPort.send(val));
        } catch (_) {
          logger.error(
              'Loki retry failed. This should be reported. https://github.com/buraktabn/one_logger/issues');
        }
      }
    }
  }

  Future<void> startLoki() async {
    if (!lokiEnabled) {
      copyWith(module: _loggerModuleName).warn('Loki URL not configured');
      return;
    }
    final receiverPort = ReceivePort();
    final isolate = await Isolate.spawn(pushIsolate, Tuple2(receiverPort.sendPort, lokiUrl!),
        debugName: 'Grafana Loki Pusher');

    try {
      _sendPort = await receiverPort.first;
    } catch (_) {
      isolate.kill();
    }
  }

  void disposeLoki() {
    _sendPort.send('exit');
  }

  Logger copyWith({String? module, LoggerOptions? options}) =>
      Logger(module: module ?? this.module, options: options ?? this.options);
}

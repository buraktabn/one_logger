import 'dart:io';
import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:one_logger/src/loki/options.dart';
import 'package:one_logger/src/loki/pusher.dart';
import 'package:tuple/tuple.dart';

import 'helper.dart';
import 'options/options.dart';

typedef LokiLabel = Map<String, String>;

const _level = 'level';

final _sendPorts = <LokiOptions, SendPort>{};

class Logger extends Equatable {
  const Logger({this.service, this.defaultModule, this.lokiOptions, this.options = defaultLevelOptions});

  final String? service;
  final String? defaultModule;
  final LokiOptions? lokiOptions;
  final LoggerOptions options;

  bool get lokiEnabled => lokiOptions != null;

  String get _loggerServiceName {
    if (service == null) {
      return 'logger';
    }
    return '$service:logger';
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
    module ??= defaultModule;
    final log = ansiPrint(msg, level: level, service: service, module: module, options: options);
    PushIsolateMessage? val;
    void send() {
      val ??= PushIsolateMessage([log], service ?? Platform.localHostname, module, labels);
      _sendPorts[lokiOptions!]!.send(val);
    }

    if (lokiEnabled) {
      try {
        send();
      } catch (_) {
        final logger = Logger(service: _loggerServiceName, options: options);
        logger.warn('Loki is not yet active or disposed.');
        logger.warn('Trying to restart it');
        try {
          startLoki().then((_) => send());
        } catch (_) {
          logger.error(
              'Loki retry failed. This should be reported. https://github.com/buraktabn/one_logger/issues');
        }
      }
    }
  }

  Future<void> startLoki() async {
    if (!lokiEnabled) {
      Logger(service: _loggerServiceName, options: options).warn('Loki URL not configured');
      return;
    }
    final receiverPort = ReceivePort();
    final isolate = await Isolate.spawn(pushIsolate, Tuple2(receiverPort.sendPort, lokiOptions!),
        debugName: 'Grafana Loki Pusher');

    try {
      final sendPort = await receiverPort.first;
      if (!_sendPorts.containsKey(lokiOptions)) {
        _sendPorts[lokiOptions!] = sendPort;
      }
    } catch (_) {
      isolate.kill();
    }
  }

  void disposeLoki() {
    _sendPorts[lokiOptions!]!.send('exit');
  }

  Logger copyWith({String? service, String? defaultModule, LoggerOptions? options, LokiOptions? lokiOptions}) => Logger(
      service: service ?? this.service,
      defaultModule: defaultModule ?? this.defaultModule,
      options: options ?? this.options,
      lokiOptions: lokiOptions ?? this.lokiOptions);

  @override
  List<Object?> get props => [service, defaultModule, options, lokiOptions];

  @override
  bool? get stringify => true;
}

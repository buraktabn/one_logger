import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import 'style.dart';

enum Level {
  trace,
  info,
  warn,
  error,
  debug;

  Tuple2<String, LogStyle> logStyleFromOptions(LoggerOptions options) {
    return Tuple2(toEqualSizeText(), options.toLevelMap()[this]!);
  }

  String toEqualSizeText() {
    int max = 0;
    for (final value in values) {
      final len = value.name.length;
      if (len > max) {
        max = len;
      }
    }
    final diff = max - name.length;
    if (diff > 0) {
      return List.filled(diff, ' ').join() + name.toUpperCase();
    }
    return name.toUpperCase();
  }

  @override
  String toString() => toEqualSizeText();
}

class LoggerOptions extends Equatable {
  final LogStyle trace;
  final LogStyle info;
  final LogStyle warn;
  final LogStyle error;
  final LogStyle debug;
  final LogStyle module;
  final LogStyle service;
  final LogStyle date;
  final bool enableAnsi;

  const LoggerOptions({
    this.trace = const LogStyle(),
    this.info = const LogStyle(textColor: textColorGreen),
    this.warn = const LogStyle(textColor: textColorMagenta),
    this.error = const LogStyle(textColor: textColorRed, attr: Attribute.reverse),
    this.debug = const LogStyle(),
    this.module = const LogStyle(textColor: textColorCyan),
    this.service = const LogStyle(textColor: textColorCyan),
    this.date = const LogStyle(attr: Attribute.dim),
    this.enableAnsi = true,
  });

  Map<Level, LogStyle> toLevelMap() {
    return {
      Level.trace: trace,
      Level.info: info,
      Level.warn: warn,
      Level.error: error,
      Level.debug: debug,
    };
  }

  @override
  List<Object?> get props => [trace, info, warn, error, debug, module, service, date, enableAnsi];

  @override
  bool? get stringify => true;
}

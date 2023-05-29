import 'dart:io';

import 'package:intl/intl.dart';
import 'package:one_logger/src/options/options.dart';
import 'package:one_logger/src/options/style.dart';

// import 'support/support_ansi.dart'
//     if (dart.library.io) 'support/support_ansi_io.dart'
//     if (dart.library.html) 'support/support_ansi_web.dart';

const defaultLevelOptions = LoggerOptions();

final defaultDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.S');

String textToAnsi(text, {LogStyle style = const LogStyle(), bool enableAnsi = true}) {
  if (!enableAnsi) {
    return text;
  }
  final fg = style.textColor == null ? '' : ';${style.textColor}';
  final bg = style.backgroundColor == null ? '' : ';${style.backgroundColor}';
  return '\x1B[${style.attr.index}$fg${bg}m$text\x1B[0m';
}

String ansiPrint(
  msg, {
  DateTime? date,
  Level level = Level.debug,
  String? service,
  String? module,
  DateFormat? dateFormat,
  LoggerOptions options = defaultLevelOptions,
  bool shouldPrint = true,
}) {
  service ??= Platform.localHostname;
  dateFormat ??= defaultDateFormat;
  date ??= DateTime.now();
  final mService = textToAnsi(service, style: options.service, enableAnsi: options.enableAnsi);
  final mModule = module == null ? '' : ':${textToAnsi(module, style: options.module, enableAnsi: options.enableAnsi)}';
  final mDate = textToAnsi('[${dateFormat.format(date)}]', style: options.date, enableAnsi: options.enableAnsi);
  final levelStyle = level.logStyleFromOptions(options);
  final mLevel = textToAnsi(levelStyle.item1, style: levelStyle.item2, enableAnsi: options.enableAnsi);
  final log = '$mDate $mLevel $mService$mModule $msg';
  if (shouldPrint) print(log);
  return log;
  // date, level, module, msg
}

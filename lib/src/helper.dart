import 'dart:io';

import 'package:intl/intl.dart';
import 'package:one_logger/src/options/options.dart';
import 'package:one_logger/src/options/style.dart';
import 'support/support_ansi.dart'
    if (dart.library.io) 'support/support_ansi_io.dart'
    if (dart.library.html) 'support/support_ansi_web.dart';

const defaultLevelOptions = LoggerOptions();

final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

String textToAnsi(text, {LogStyle style = const LogStyle()}) {
  if (!supportsAnsiColor) {
    return text;
  }
  final fg = style.textColor == null ? '' : ';${style.textColor}';
  final bg = style.backgroundColor == null ? '' : ';${style.backgroundColor}';
  return '\x1B[${style.attr.index}$fg${bg}m$text\x1B[0m';
}

void ansiPrint(msg,
    {DateTime? date,
    Level level = Level.debug,
    String? module,
    LoggerOptions options = defaultLevelOptions}) {
  module ??= Platform.localHostname;
  date ??= DateTime.now();
  final mModule = textToAnsi('$module:', style: options.module);
  final mDate = textToAnsi('[${dateFormat.format(date)}]', style: options.date);
  final levelStyle = level.logStyleFromOptions(options);
  final mLevel = textToAnsi(levelStyle.item1, style: levelStyle.item2);
  print('$mDate $mLevel $mModule $msg');
  // date, level, module, msg
}

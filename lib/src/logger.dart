import 'helper.dart';
import 'options/options.dart';

class Logger {
  const Logger({this.module, this.options = defaultLevelOptions});

  final String? module;
  final LoggerOptions options;

  void info(msg, [String? module]) => _print(msg, Level.info, module);

  void warn(msg, [String? module]) => _print(msg, Level.warn, module);

  void error(msg, [StackTrace? stackTrace, String? module]) => _print('$msg\n$stackTrace', Level.error, module);

  void debug(msg, [String? module]) => _print(msg, Level.debug, module);

  void _print(msg, Level level, [String? module]) {
    ansiPrint(msg, level: level, module: module ?? this.module, options: options);
  }
}

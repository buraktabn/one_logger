import 'package:one_logger/src/options/options.dart';

abstract class LoggerFilter {
  const LoggerFilter();

  bool shouldPrintLog(Level level);

  bool shouldPushLog(Level level);
}

class DevelopmentLoggerFilter extends LoggerFilter {
  const DevelopmentLoggerFilter();

  @override
  bool shouldPrintLog(Level level) {
    return true;
  }

  @override
  bool shouldPushLog(Level level) {
    return true;
  }
}

class ProductionLoggerFilter extends LoggerFilter {
  const ProductionLoggerFilter();

  @override
  bool shouldPrintLog(Level level) {
    return level == Level.warn;
  }

  @override
  bool shouldPushLog(Level level) {
    return true;
  }
}
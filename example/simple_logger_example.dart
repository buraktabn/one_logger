import 'package:one_logger/one_logger.dart';

void main() async {
  const logger = Logger(
    service: 'one_logger',
    defaultModule: 'example',
    filter: MyLogFilter() // Filtering debug
  );

  logger.info('this is info');
  logger.warn('this is warn');
  logger.error('this is error');
  logger.debug('this is debug');

  try {
    final list = [];
    list[2];
  } catch (e, st) {
    logger.error(e, stackTrace: st);
  }
}


class MyLogFilter extends LoggerFilter {
  const MyLogFilter();
  
  @override
  bool shouldPrintLog(Level level) {
    // return level.index < Level.debug.index;
    return true;
  }

  @override
  bool shouldPushLog(Level level) {
    return true;
  }  
}
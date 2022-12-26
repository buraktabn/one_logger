import 'package:one_logger/one_logger.dart';
import 'package:one_logger/src/options/filter.dart';

void main() async {
  const logger = Logger(
    service: 'one_logger',
    defaultModule: 'example',
    lokiOptions: LokiOptions(lokiUrl: 'http://morhpt.sv:3100/loki/api/v1/push'),
    filter: MyLogFilter() // Filtering debug
  );
  final batchLogger = logger.copyWith(
    lokiOptions: LokiOptions(
      lokiUrl: 'http://morhpt.sv:3100/loki/api/v1/push',
      batchEvery: Duration(seconds: 5),
    ),
  );

  await logger.startLoki();
  await batchLogger.startLoki();

  logger.warn('this is warn');
  logger.error('this is error');
  logger.debug('this is debug');
  logger.debug('this is debug');

  try {
    final list = [];
    list[2];
  } catch (e, st) {
    logger.error(e, stackTrace: st);
  }

  for (final i in List.generate(7, (index) => index)) {
    await Future.delayed(const Duration(milliseconds: 1000));
    batchLogger.info('$i this is info from batch');
  }

  logger.disposeLoki();
  batchLogger.disposeLoki();
}


class MyLogFilter extends LoggerFilter {
  const MyLogFilter();
  
  @override
  bool shouldPrintLog(Level level) {
    return level.index < Level.debug.index;
  }

  @override
  bool shouldPushLog(Level level) {
    return true;
  }  
}
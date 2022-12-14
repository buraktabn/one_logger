import 'package:one_logger/one_logger.dart';

void main() async {
  final logger = Logger(
    service: 'one_logger',
    defaultModule: 'example',
    lokiOptions: LokiOptions(lokiUrl: 'http://morhpt.sv:3100/loki/api/v1/push'),
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

  try {
    final list = [];
    list[2];
  } catch (e, st) {
    logger.error(e, stackTrace: st);
  }

  for (final i in List.generate(100, (index) => index)) {
    batchLogger.info('$i this is info from batch');

    await Future.delayed(const Duration(milliseconds: 100));
  }

  logger.disposeLoki();
  batchLogger.disposeLoki();
}

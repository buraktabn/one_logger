import 'package:one_logger/one_logger.dart';

void main() async {
  final logger = Logger(module: 'one_logger', lokiUrl: 'http://morhpt.sv:3100/loki/api/v1/push');

  await logger.startLoki();

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

  await Future.delayed(const Duration(milliseconds: 500));
  logger.disposeLoki();
}

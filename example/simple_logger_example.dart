import 'package:one_logger/one_logger.dart';

void main() {
  final logger = Logger(module: 'blockchain');

  logger.info('this is info');
  logger.warn('this is warn');
  logger.error('this is error');
  logger.debug('this is debug');
}

import 'package:equatable/equatable.dart';

class LokiOptions extends Equatable {
  const LokiOptions({required this.lokiUrl, this.batchEvery});

  final String lokiUrl;
  final Duration? batchEvery;

  @override
  List<Object?> get props => [lokiUrl, batchEvery];

  @override
  bool? get stringify => true;
}

import 'package:equatable/equatable.dart';

// ignore: unused_field,constant_identifier_names
enum Attribute { resetAll, bright, dim, underline, _, blink, __, reverse, hidden }

const textColorBlack = 30;
const textColorRed = 31;
const textColorGreen = 32;
const textColorYellow = 33;
const textColorBlue = 34;
const textColorMagenta = 35;
const textColorCyan = 36;
const textColorWhite = 37;

const backgroundColorBlack = 40;
const backgroundColorRed = 41;
const backgroundColorGreen = 42;
const backgroundColorYellow = 43;
const backgroundColorBlue = 44;
const backgroundColorMagenta = 45;
const backgroundColorCyan = 46;
const backgroundColorWhite = 47;

class LogStyle extends Equatable {
  final int? textColor;
  final int? backgroundColor;
  final Attribute attr;

  const LogStyle({this.textColor, this.backgroundColor, this.attr = Attribute.resetAll});

  @override
  List<Object?> get props => [textColor, backgroundColor, attr];

  @override
  bool? get stringify => true;
}

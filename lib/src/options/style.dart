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

  const LogStyle.textBlack({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorBlack;

  const LogStyle.textRed({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorRed;

  const LogStyle.textGreen({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorGreen;

  const LogStyle.textYellow({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorYellow;

  const LogStyle.textBlue({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorBlue;

  const LogStyle.textMagenta({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorMagenta;

  const LogStyle.textCyan({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorCyan;

  const LogStyle.textWhite({this.backgroundColor, this.attr = Attribute.resetAll}) : textColor = textColorWhite;

  const LogStyle.backgroundBlack({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorBlack;

  const LogStyle.backgroundRed({this.textColor, this.attr = Attribute.resetAll}) : backgroundColor = backgroundColorRed;

  const LogStyle.backgroundGreen({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorGreen;

  const LogStyle.backgroundYellow({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorYellow;

  const LogStyle.backgroundBlue({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorBlue;

  const LogStyle.backgroundMagenta({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorMagenta;

  const LogStyle.backgroundCyan({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorCyan;

  const LogStyle.backgroundWhite({this.textColor, this.attr = Attribute.resetAll})
      : backgroundColor = backgroundColorWhite;

  @override
  List<Object?> get props => [textColor, backgroundColor, attr];

  @override
  bool? get stringify => true;
}

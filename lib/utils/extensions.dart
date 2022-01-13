import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get accentColor => Theme.of(this).colorScheme.secondary;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get primaryColorDark => Theme.of(this).primaryColorDark;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get textColor => Theme.of(this).textTheme.bodyText1!.color!;
  Color get dialogBackgroundColor => Theme.of(this).dialogBackgroundColor;
  Brightness get brightness => Theme.of(this).brightness;
  TextStyle get headline4 => Theme.of(this).textTheme.headline4!;
  TextStyle get headline5 => Theme.of(this).textTheme.headline5!;
  TextStyle get headline6 => Theme.of(this).textTheme.headline6!;
  TextStyle get bodyText1 => Theme.of(this).textTheme.bodyText1!;
  TextStyle get bodyText2 => Theme.of(this).textTheme.bodyText2!;
  TextStyle get sutitle1 => Theme.of(this).textTheme.subtitle1!;
  TextStyle get sutitle2 => Theme.of(this).textTheme.subtitle2!;
  double get paddingTop => MediaQuery.of(this).padding.top;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}



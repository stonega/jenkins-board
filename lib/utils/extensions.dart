import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jenkins_board/widgets/toast_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get accentColor => Theme.of(this).colorScheme.secondary;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get primaryColorDark => Theme.of(this).primaryColorDark;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get textColor => Theme.of(this).textTheme.bodyText1!.color!;
  Color get dialogBackgroundColor => Theme.of(this).dialogBackgroundColor;
  AppLocalizations get S => AppLocalizations.of(this)!;
  Locale get locale => Localizations.localeOf(this);
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
  void toast(String title,
      {IconData? icon, ToastGravity gravity = ToastGravity.BOTTOM}) {
    final fToast = FToast();
    fToast.init(this);
    fToast.showToast(
      child: ToastWidget(title, icon: icon),
      gravity: gravity,
      toastDuration: const Duration(seconds: 2),
    );
  }
}

extension IntExtension on int {
  String get toTime =>
      '${(this ~/ 60).toString().padLeft(2, '0')}:${(truncate() % 60).toString().padLeft(2, '0')}';
}

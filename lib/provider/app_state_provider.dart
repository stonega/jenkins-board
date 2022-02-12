import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/model/app_state.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
    (ref) => AppStateNotifier());

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(initState);

  static AppState get initState {
    final themeData = ThemeData(
      shadowColor: Colors.black.withOpacity(0.1),
      appBarTheme: const AppBarTheme(color: Color(0xFFC9CCD5)),
      primaryColor: Colors.white,
      primaryColorLight: Colors.grey[200],
      primaryColorDark: Colors.greenAccent,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
      ).copyWith(
        secondary: const Color(
          0xFFCC3631,
        ),
      ),
    );
    const locale = Locale('en', 'US');
    const authed = false;
    return AppState(
        themeData: themeData,
        themeMode: ThemeMode.system,
        locale: locale,
        authed: authed);
  }

  setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }
}

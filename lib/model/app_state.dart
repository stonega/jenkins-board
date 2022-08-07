import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  factory AppState(
      {required ThemeData themeData,
      required Locale locale,
      required ThemeMode themeMode,
      required bool authed,
      required double jobPanelHeight}) = _AppState;
}

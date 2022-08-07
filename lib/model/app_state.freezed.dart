// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppState {
  ThemeData get themeData => throw _privateConstructorUsedError;
  Locale get locale => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  bool get authed => throw _privateConstructorUsedError;
  double get jobPanelHeight => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
  $Res call(
      {ThemeData themeData,
      Locale locale,
      ThemeMode themeMode,
      bool authed,
      double jobPanelHeight});
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;

  @override
  $Res call({
    Object? themeData = freezed,
    Object? locale = freezed,
    Object? themeMode = freezed,
    Object? authed = freezed,
    Object? jobPanelHeight = freezed,
  }) {
    return _then(_value.copyWith(
      themeData: themeData == freezed
          ? _value.themeData
          : themeData // ignore: cast_nullable_to_non_nullable
              as ThemeData,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as Locale,
      themeMode: themeMode == freezed
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      authed: authed == freezed
          ? _value.authed
          : authed // ignore: cast_nullable_to_non_nullable
              as bool,
      jobPanelHeight: jobPanelHeight == freezed
          ? _value.jobPanelHeight
          : jobPanelHeight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$$_AppStateCopyWith(
          _$_AppState value, $Res Function(_$_AppState) then) =
      __$$_AppStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {ThemeData themeData,
      Locale locale,
      ThemeMode themeMode,
      bool authed,
      double jobPanelHeight});
}

/// @nodoc
class __$$_AppStateCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements _$$_AppStateCopyWith<$Res> {
  __$$_AppStateCopyWithImpl(
      _$_AppState _value, $Res Function(_$_AppState) _then)
      : super(_value, (v) => _then(v as _$_AppState));

  @override
  _$_AppState get _value => super._value as _$_AppState;

  @override
  $Res call({
    Object? themeData = freezed,
    Object? locale = freezed,
    Object? themeMode = freezed,
    Object? authed = freezed,
    Object? jobPanelHeight = freezed,
  }) {
    return _then(_$_AppState(
      themeData: themeData == freezed
          ? _value.themeData
          : themeData // ignore: cast_nullable_to_non_nullable
              as ThemeData,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as Locale,
      themeMode: themeMode == freezed
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      authed: authed == freezed
          ? _value.authed
          : authed // ignore: cast_nullable_to_non_nullable
              as bool,
      jobPanelHeight: jobPanelHeight == freezed
          ? _value.jobPanelHeight
          : jobPanelHeight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_AppState implements _AppState {
  _$_AppState(
      {required this.themeData,
      required this.locale,
      required this.themeMode,
      required this.authed,
      required this.jobPanelHeight});

  @override
  final ThemeData themeData;
  @override
  final Locale locale;
  @override
  final ThemeMode themeMode;
  @override
  final bool authed;
  @override
  final double jobPanelHeight;

  @override
  String toString() {
    return 'AppState(themeData: $themeData, locale: $locale, themeMode: $themeMode, authed: $authed, jobPanelHeight: $jobPanelHeight)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppState &&
            const DeepCollectionEquality().equals(other.themeData, themeData) &&
            const DeepCollectionEquality().equals(other.locale, locale) &&
            const DeepCollectionEquality().equals(other.themeMode, themeMode) &&
            const DeepCollectionEquality().equals(other.authed, authed) &&
            const DeepCollectionEquality()
                .equals(other.jobPanelHeight, jobPanelHeight));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(themeData),
      const DeepCollectionEquality().hash(locale),
      const DeepCollectionEquality().hash(themeMode),
      const DeepCollectionEquality().hash(authed),
      const DeepCollectionEquality().hash(jobPanelHeight));

  @JsonKey(ignore: true)
  @override
  _$$_AppStateCopyWith<_$_AppState> get copyWith =>
      __$$_AppStateCopyWithImpl<_$_AppState>(this, _$identity);
}

abstract class _AppState implements AppState {
  factory _AppState(
      {required final ThemeData themeData,
      required final Locale locale,
      required final ThemeMode themeMode,
      required final bool authed,
      required final double jobPanelHeight}) = _$_AppState;

  @override
  ThemeData get themeData;
  @override
  Locale get locale;
  @override
  ThemeMode get themeMode;
  @override
  bool get authed;
  @override
  double get jobPanelHeight;
  @override
  @JsonKey(ignore: true)
  _$$_AppStateCopyWith<_$_AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

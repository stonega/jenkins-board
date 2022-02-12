import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/view/home.dart';
import 'package:jenkins_board/view/login/login.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (_) => '/home/undefined'),
    GoRoute(
      path: '/home/:type',
      pageBuilder: (context, state) {
        final type = state.params['type'];
        final settingType = SettingType.values.byName(type!);
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: HomePage(
            type: settingType,
            buildUrl: state.extra as String?,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
  redirect: (state) {
    final token = HiveBox.getToken();
    final loginloc = state.namedLocation('login');
    final loggingIn = state.subloc == loginloc;
    if (token == '') {
      return loggingIn
          ? null
          : state.namedLocation(
              'login',
            );
    }
  },
);

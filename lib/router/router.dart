import 'package:go_router/go_router.dart';
import 'package:jenkins_board/model/branch.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/view/home.dart';
import 'package:jenkins_board/view/login/login.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => const HomePage(type: SettingType.settings),
    ),
    GoRoute(
      name: 'chooseJobs',
      path: '/choose_jobs',
      builder: (context, state) => const HomePage(type: SettingType.chooseJobs),
    ),
    GoRoute(
      name: 'buildDetail',
      path: '/build_detail',
      builder: (context, state) => HomePage(
          type: SettingType.buildDetail, buildUrl: state.extra as String),
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

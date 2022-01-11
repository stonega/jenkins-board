import 'package:go_router/go_router.dart';
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

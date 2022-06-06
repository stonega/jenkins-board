import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jenkins_board/api/api_service.dart';
import 'package:jenkins_board/provider/app_state_provider.dart';
import 'package:jenkins_board/router/router.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_notifier/local_notifier.dart';

void main() async {
  await Hive.initFlutter();
  await HiveBox.init();
  await ApiService.init();
  await localNotifier.setup(
    appName: 'Jenkins board',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Jenkins board',
      theme: appState.themeData,
      themeMode: appState.themeMode,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: appState.locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
      ],
    );
  }
}

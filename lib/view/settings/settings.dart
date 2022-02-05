import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/provider/app_state_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    return SettingWrapper(
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView(
            children: [
              Text(
                'Language',
                style: context.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Radio<Locale>(
                    groupValue: appState.locale,
                    value: const Locale('en', 'US'),
                    activeColor: context.accentColor,
                    onChanged: (Locale? locale) {
                      ref.read(appStateProvider.notifier).setLocale(locale!);
                    },
                  ),
                  const Text('English')
                ],
              ),
              Row(
                children: [
                  Radio<Locale>(
                    groupValue: appState.locale,
                    value: const Locale('zh', 'CN'),
                    activeColor: context.accentColor,
                    onChanged: (Locale? locale) {
                      ref.read(appStateProvider.notifier).setLocale(locale!);
                    },
                  ),
                  const Text('中文')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

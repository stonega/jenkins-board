import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/provider/app_state_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/utils/helper.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';
import 'package:line_icons/line_icons.dart';

const githubUrl = "https://github.com/stonega/jenkins-board";

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
              const SizedBox(
                height: 20,
              ),
              Text(
                'About',
                style: context.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Jenkins Board',
                  style:
                      context.bodyText1.copyWith(color: context.accentColor)),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Helper.launchURL(githubUrl);
                  context.toast('Opened in browser');
                },
                child: Row(
                  children: const [
                    Icon(
                      LineIcons.github,
                    ),
                    SizedBox(width: 10),
                    Text('GitHub')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

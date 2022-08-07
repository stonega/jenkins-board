import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/provider/app_state_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/utils/helper.dart';
import 'package:jenkins_board/widgets/custom_button.dart';
import 'package:jenkins_board/widgets/custom_textfield.dart';
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
                'Job panel height',
                style: context.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Radio<double>(
                    groupValue: appState.jobPanelHeight,
                    value: 200,
                    activeColor: context.accentColor,
                    onChanged: (value) {
                      ref
                          .read(appStateProvider.notifier)
                          .setJobPanelHeight(200);
                    },
                  ),
                  const Text('Medium')
                ],
              ),
              Row(
                children: [
                  Radio<double>(
                    groupValue: appState.jobPanelHeight,
                    value: 400,
                    activeColor: context.accentColor,
                    onChanged: (vlaue) {
                      ref
                          .read(appStateProvider.notifier)
                          .setJobPanelHeight(400);
                    },
                  ),
                  const Text('High')
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Update token', style: context.headline5),
              const SizedBox(
                height: 10,
              ),
              const RegenerateTokenWidget(),
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

class RegenerateTokenWidget extends StatefulWidget {
  const RegenerateTokenWidget({Key? key}) : super(key: key);

  @override
  State<RegenerateTokenWidget> createState() => _RegenerateTokenWidgetState();
}

class _RegenerateTokenWidgetState extends State<RegenerateTokenWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String _error;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _error = '';
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: InputWrapper(
            error: _error,
            horizontalPadding: 0,
            compact: true,
            inputBox: CustomTextField(
              controller: _usernameController,
              placeHolder: 'Username',
              inputType: TextInputType.name,
            ),
          ),
        ),
        SizedBox(
          width: 260,
          child: InputWrapper(
            error: '',
            compact: true,
            inputBox: CustomTextField(
              obscureText: true,
              controller: _passwordController,
              placeHolder: 'Passsword',
              inputType: TextInputType.visiblePassword,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          height: 40,
          child: CustomButton(
            loading: _loading,
            onPressed: _submit,
            child: const Text('Update'),
          ),
        )
      ],
    );
  }

  _submit() async {
    setState(() {
      _error = '';
      _loading = true;
    });
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username == '' || password == '') {
      setState(() {
        _error = 'Username or password can not be empty';
      });
      return;
    }
    try {
      await JenkinsApi.updateApiToken(username, password);
      context.toast('Token update successfully');
      _usernameController.text = '';
      _passwordController.text = '';
    } catch (e) {
      context.toast('Token update failed, try again');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}

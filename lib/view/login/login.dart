import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/custom_button.dart';
import 'package:jenkins_board/widgets/custom_textfield.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _tokenController;
  late TextEditingController _urlController;
  late String _error;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _tokenController = TextEditingController();
    _urlController = TextEditingController();
    _error = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/stay-safe.png',
                height: 200,
              ),
              Text(
                'Jenkins Board',
                style: context.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              InputWrapper(
                title: 'Username',
                inputBox: CustomTextField(
                  controller: _usernameController,
                  placeHolder: 'Username',
                  inputType: TextInputType.name,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputWrapper(
                title: 'API Token',
                inputBox: CustomTextField(
                  controller: _tokenController,
                  placeHolder: 'Password',
                  inputType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 340,
                height: 50,
                child: CustomButton(
                  onPressed: _submit,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    setState(() {
      _error = '';
    });
    final username = _usernameController.text.trim();
    final token = _tokenController.text.trim();
    if (username == '') {
      setState(() => _error = 'Username can not be empty');
      return;
    }
    try {
      await JenkinsApi.login(username, token, 'https://cicd.abmatrix.cn');
      context.go('/');
    } catch (e) {
      setState(() => _error = 'Auth failed');
    }
  }
}

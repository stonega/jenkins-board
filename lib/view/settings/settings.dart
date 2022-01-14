import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';

class SettingsPage extends ConsumerWidget {
  final VoidCallback onClose;
  const SettingsPage({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingWrapper(
      onClose: onClose,
      child: ListView(
        children: [
          Text('data')
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/build_task_button.dart';
import 'package:jenkins_board/widgets/custom_button.dart';
import 'package:line_icons/line_icons.dart';

class Topbar extends ConsumerWidget {
  const Topbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 660) {
          return Column(
            children: const [
              _LeftPanel(),
              SizedBox(
                height: 10,
              ),
              _RightPanel()
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [_LeftPanel(), _RightPanel()],
        );
      }),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = HiveBox.getUsername();
    return Row(
      children: [
        Text('Hi $username', style: context.headline4),
        const SizedBox(
          width: 20,
        ),
        CustomButton(
          onPressed: () {
            context.go('/home/choose_jobs');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(context.S.addJob),
                const Icon(
                  LineIcons.plusCircle,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RightPanel extends ConsumerWidget {
  const _RightPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const BuildTasksButton(),
        const SizedBox(
          width: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: context.primaryColorLight,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: ref.read(jobsProvider.notifier).refresh,
                splashRadius: 20,
                icon: Icon(
                  LineIcons.alternateRedo,
                  color: context.primaryColorDark,
                  size: 20,
                ),
                tooltip: context.S.refresh,
              ),
              Container(
                width: 2,
                height: 20,
                color: context.primaryColorDark,
              ),
              IconButton(
                onPressed: () {
                  context.go('/home/settings');
                },
                splashRadius: 20,
                icon: Icon(
                  LineIcons.cog,
                  color: context.primaryColorDark,
                ),
                tooltip: context.S.settings,
              ),
              Container(
                width: 2,
                height: 20,
                color: context.primaryColorDark,
              ),
              IconButton(
                onPressed: () async => await _logout(context),
                splashRadius: 20,
                icon: Icon(
                  LineIcons.shareSquare,
                  color: context.primaryColorDark,
                ),
                tooltip: context.S.logout,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future _logout(BuildContext context) async {
    await JenkinsApi.logout();
    context.push('/');
  }
}

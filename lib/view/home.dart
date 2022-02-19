// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/view/settings/build_detail.dart';
import 'package:jenkins_board/view/settings/build_task.dart';
import 'package:jenkins_board/view/settings/choose_jobs.dart';
import 'package:jenkins_board/view/settings/settings.dart';
import 'package:jenkins_board/widgets/build_task_button.dart';
import 'package:jenkins_board/widgets/custom_button.dart';
import 'package:jenkins_board/widgets/job_panel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:reorderables/reorderables.dart';

enum SettingType { choose_jobs, settings, build_detail, build_tasks, undefined }

class HomePage extends StatelessWidget {
  const HomePage(
      {SettingType? type, this.buildUrl, this.isFirst = true, Key? key})
      : settingType = type ?? SettingType.undefined,
        super(key: key);
  final SettingType settingType;
  final String? buildUrl;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeView(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _getBody(),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (settingType) {
      case SettingType.settings:
        return const SettingsPage();
      case SettingType.choose_jobs:
        return ChooseJobsPage();
      case SettingType.build_detail:
        return BuildDetailPage(
          url: buildUrl,
        );
      case SettingType.build_tasks:
        return BuildTasksPage();
      default:
        return const Center();
    }
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(jobsProvider);
    final username = HiveBox.getUsername();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
          child: Row(
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
              const Spacer(),
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
                      onPressed: () => _logout(context),
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 30, 15),
          child: ReorderableWrap(
            onReorder: ref.read(jobsProvider.notifier).reOrder,
            spacing: 20,
            runSpacing: 20,
            children: [for (var j in jobs) JobPanel(job: j)],
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context) {
    JenkinsApi.logout();
    context.push('/');
  }
}

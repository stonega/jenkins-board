// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/view/settings/build_detail.dart';
import 'package:jenkins_board/view/settings/build_task.dart';
import 'package:jenkins_board/view/settings/choose_jobs.dart';
import 'package:jenkins_board/view/settings/settings.dart';
import 'package:jenkins_board/widgets/job_panel.dart';
import 'package:jenkins_board/widgets/topbar.dart';
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
    return ListView(
      children: [
        const Topbar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
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
}

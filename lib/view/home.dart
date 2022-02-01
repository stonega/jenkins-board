import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/view/settings/build_detail.dart';
import 'package:jenkins_board/view/settings/choose_jobs.dart';
import 'package:jenkins_board/view/settings/settings.dart';
import 'package:jenkins_board/widgets/custom_button.dart';
import 'package:jenkins_board/widgets/job_panel.dart';
import 'package:line_icons/line_icons.dart';

enum SettingType { chooseJobs, settings, buildDetail, undefined }

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
              duration: const Duration(milliseconds: 300), child: _getBody()),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (settingType) {
      case SettingType.settings:
        return const SettingsPage();
      case SettingType.chooseJobs:
        return ChooseJobsPage();
      case SettingType.buildDetail:
        return BuildDetailPage(buildUrl!);
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
                  context.push('/choose_jobs');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: const [
                      Text('Add job'),
                      Icon(
                        LineIcons.plusCircle,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
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
                      ),
                      tooltip: 'Refresh',
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: context.primaryColorDark,
                    ),
                    IconButton(
                      onPressed: () {
                        context.push('/settings');
                      },
                      splashRadius: 20,
                      icon: Icon(
                        LineIcons.cog,
                        color: context.primaryColorDark,
                      ),
                      tooltip: 'Settings',
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
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 30, 15),
          child: Wrap(
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

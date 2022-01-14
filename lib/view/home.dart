import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/view/settings/choose_jobs.dart';
import 'package:jenkins_board/view/settings/settings.dart';
import 'package:jenkins_board/widgets/job_panel.dart';
import 'package:line_icons/line_icons.dart';

enum SettingType { chooseJobs, settings, undefined }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget _body;
  @override
  void initState() {
    super.initState();
    _body = const Center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomeView(
            onChange: (settingType) {
              switch (settingType) {
                case SettingType.chooseJobs:
                  setState(() => _body = ChooseJobsPage(
                        onClose: _back,
                      ));
                  break;
                case SettingType.settings:
                  setState(() => _body = SettingsPage(
                        onClose: _back,
                      ));
                  break;
                default:
                  _back();
                  break;
              }
            },
          ),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 300), child: _body),
        ],
      ),
    );
  }

  void _back() {
    setState(() => _body = const Center());
  }
}

class HomeView extends ConsumerWidget {
  final ValueChanged<SettingType> onChange;
  const HomeView({required this.onChange, Key? key}) : super(key: key);

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
              IconButton(
                onPressed: () {
                  onChange(SettingType.chooseJobs);
                },
                splashRadius: 20,
                icon: const Icon(LineIcons.plusCircle),
                tooltip: 'Add job',
              ),
              IconButton(
                onPressed: ref.read(jobsProvider.notifier).refresh,
                splashRadius: 20,
                icon: const Icon(LineIcons.alternateRedo),
                tooltip: 'Refresh',
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: context.primaryColorLight,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => onChange(SettingType.settings),
                      splashRadius: 20,
                      icon: Icon(
                        LineIcons.cog,
                        color: context.primaryColorDark,
                      ),
                      tooltip: 'Settings',
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
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
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

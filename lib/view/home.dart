import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/view/settings/choose_jobs.dart';
import 'package:jenkins_board/view/settings/settings.dart';
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
    return Stack(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text('My Jobs', style: context.headline4),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                onChange(SettingType.chooseJobs);
              },
              splashRadius: 20,
              icon: const Icon(LineIcons.plusCircle),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.cogs),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Wrap(
          spacing: 20,
          children: [
            for (var j in jobs)
              Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: Text(j.name,
                    style:
                        context.headline6.copyWith(color: context.accentColor)),
              )
          ],
        ),
      ),
    );
  }
}

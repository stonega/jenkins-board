import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/job_group.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/select_job.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';

class ChooseJobsPage extends ConsumerWidget {
  final VoidCallback onClose;
  ChooseJobsPage({required this.onClose, Key? key}) : super(key: key);

  final groupsProvider = FutureProvider<List<JobGroup>>((ref) async {
    return JenkinsApi.getAllJobs();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobGroups = ref.watch(groupsProvider);
    final jobs = ref.watch(jobsProvider);
    return SettingWrapper(
      onClose: onClose,
      child: jobGroups.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (groups) {
          return Center(
            child: SizedBox(
              width: 600,
              height: double.infinity,
              child: ListView(
                children: [
                  for (var g in groups)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.name,
                          style: context.headline5.copyWith(
                              color: context.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: g.jobs.length,
                          addAutomaticKeepAlives: false,
                          itemBuilder: (context, index) {
                            final selected = jobs.contains(g.jobs[index]);
                            return SelectJob(
                              g.jobs[index],
                              onTap: () {
                                if (selected) {
                                  ref
                                      .read(jobsProvider.notifier)
                                      .remove(g.jobs[index]);
                                } else {
                                  ref
                                      .read(jobsProvider.notifier)
                                      .add(g.jobs[index]);
                                }
                              },
                              selected: selected,
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

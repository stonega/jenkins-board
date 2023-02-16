import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/job_group.dart';
import 'package:jenkins_board/provider/jobs_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/select_job.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';

class ChooseJobsPage extends ConsumerWidget {
  ChooseJobsPage({Key? key}) : super(key: key);

  final groupsProvider = FutureProvider<List<JobGroup>>((ref) async {
    return JenkinsApi.getAllJobs();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobGroups = ref.watch(groupsProvider);
    final jobs = ref.watch(jobsProvider);
    return SettingWrapper(
      child: jobGroups.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (groups) {
          return Center(
            child: SizedBox(
              width: 600,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  for (var g in groups)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return Text(
                            g.name,
                            style: context.headline5.copyWith(
                                color: context.accentColor,
                                fontWeight: FontWeight.bold),
                          );
                        }
                        final selected = jobs.contains(g.jobs[index - 1]);
                        return SelectJob(
                          g.jobs[index - 1],
                          onTap: () {
                            if (selected) {
                              ref
                                  .read(jobsProvider.notifier)
                                  .remove(g.jobs[index - 1]);
                            } else {
                              ref
                                  .read(jobsProvider.notifier)
                                  .add(g.jobs[index - 1]);
                            }
                          },
                          selected: selected,
                        );
                      }, childCount: g.jobs.length + 1),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

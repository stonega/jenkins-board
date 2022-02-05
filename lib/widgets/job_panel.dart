import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/branch.dart';
import 'package:jenkins_board/model/job.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/running_widget.dart';
import 'package:jenkins_board/widgets/toast_widget.dart';
import 'package:line_icons/line_icons.dart';

class JobPanel extends ConsumerWidget {
  JobPanel({required this.job, Key? key}) : super(key: key);
  final Job job;

  final branchesProvider =
      FutureProvider.autoDispose.family<List<Branch>, Job>((ref, job) async {
    return JenkinsApi.getJobDetail(job);
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: _calculateWidth(context),
      decoration: BoxDecoration(
          color: context.primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.headline5.copyWith(
                  color: context.accentColor, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ref.watch(branchesProvider(job)).when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (err, stack) {
                    return const Text('Error');
                  },
                  data: (data) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(
                            data[index].name,
                            style: context.headline6,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              final url = await JenkinsApi.recentBuildUrl(
                                  data[index].url);
                              if (url != null) {
                                context.go('/build_detail', extra: url);
                              } else {
                                _showToast(context,
                                    content: 'No build', icon: LineIcons.info);
                              }
                            },
                            child: (data[index].isRunning)
                                ? const RunningWidget()
                                : CircleAvatar(
                                    radius: 6,
                                    backgroundColor: data[index].statusColor,
                                  ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              LineIcons.running,
                              color: context.accentColor,
                            ),
                            onPressed: () => _newBuild(context, data[index]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
          )
        ],
      ),
    );
  }

  Future _newBuild(BuildContext context, Branch branch) async {
    try {
      await JenkinsApi.newBuild(branch);
      _showToast(context,
          content: 'Build started, hope it goes well!',
          icon: LineIcons.running);
    } catch (e) {
      log(e.toString());
    }
  }

  void _showToast(BuildContext context,
      {required String content, required IconData icon}) {
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: ToastWidget(content, icon: icon),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  double _calculateWidth(BuildContext context) {
    final width = context.width;
    if (width > 990) {
      return (width - 90) / 3;
    }
    if (width > 660) {
      return (width - 70) / 2;
    }
    return width - 30;
  }
}

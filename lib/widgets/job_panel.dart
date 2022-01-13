import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/branch.dart';
import 'package:jenkins_board/model/job.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/widgets/toast_widget.dart';
import 'package:line_icons/line_icons.dart';

class JobPanel extends ConsumerWidget {
  final Job job;
  JobPanel({required this.job, Key? key}) : super(key: key);

  final branchesProvider =
      FutureProvider.autoDispose.family<List<Branch>, Job>((ref, job) async {
    return JenkinsApi.getJobDetail(job);
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.amberAccent, borderRadius: BorderRadius.circular(10)),
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
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: data[index].statusColor,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              LineIcons.running,
                              color: context.accentColor,
                            ),
                            tooltip: 'Run',
                            onPressed: () => _showToast(context),
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

  Future _newBuild(Branch branch) async {
    try {
      await JenkinsApi.newBuild(branch);
    } catch (e) {

    }
  }

  void _showToast(BuildContext context) {
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: const ToastWidget('Build started, hope it goes well!',
          icon: LineIcons.running),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }
}

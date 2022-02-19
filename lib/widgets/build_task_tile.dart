import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:jenkins_board/utils/helper.dart';
import 'package:jenkins_board/widgets/running_widget.dart';
import 'package:jenkins_board/widgets/timer_builder.dart';
import 'package:line_icons/line_icons.dart';

class BuildTaskTile extends StatelessWidget {
  final BuildTask task;
  const BuildTaskTile(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.accentColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.name,
                style: context.headline6,
              ),
              InkWell(
                onTap: () async {
                  context.go('/home/build_detail');
                  final url = await JenkinsApi.recentBuildUrl(task.branchUrl);
                  if (url != null) {
                    context.go('/home/build_detail', extra: url);
                  } else {
                    context.go('/');
                    context.toast('No build under the branch',
                        icon: LineIcons.infoCircle);
                  }
                },
                child: task.status == TaskStatus.running
                    ? const RunningWidget()
                    : CircleAvatar(
                        radius: 6,
                        backgroundColor: _getTextColor(task.status),
                      ),
              )
            ],
          ),
          Text(Helper.formatDate(task.startTime)),
          const SizedBox(
            height: 10,
          ),
          if (task.status == TaskStatus.running)
            TimerBuilder(startTime: task.startTime),
        ],
      ),
    );
  }

  Color _getTextColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.fail:
        return Colors.red;
      case TaskStatus.success:
        return Colors.green;
      case TaskStatus.cancel:
        return Colors.yellow[900]!;
      case TaskStatus.running:
        return Colors.yellow[900]!;
      default:
        return Colors.transparent;
    }
  }
}

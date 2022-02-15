import 'package:flutter/material.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/utils/extensions.dart';

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
      child: Row(
        children: [
          Text(task.branchName),
        ],
      ),
    );
  }
}

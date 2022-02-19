import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/provider/build_tasks_provider.dart';
import 'package:jenkins_board/utils/extensions.dart';
import 'package:line_icons/line_icons.dart';

class BuildTasksButton extends ConsumerWidget {
  const BuildTasksButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(buildTasksProvider);
    return InkWell(
      onTap: () => context.go('/home/build_tasks'),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          color: context.primaryColorLight,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          children: [
            Icon(
              LineIcons.running,
              color: context.primaryColorDark,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              tasks
                  .where((t) => t.status == TaskStatus.running)
                  .length
                  .toString(),
              style: TextStyle(
                color: context.primaryColorDark,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

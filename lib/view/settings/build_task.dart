import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/provider/build_tasks_provider.dart';
import 'package:jenkins_board/widgets/build_task_tile.dart';
import 'package:jenkins_board/widgets/setting_wrapper.dart';

class BuildTasksPage extends ConsumerWidget {
  BuildTasksPage({Key? key}) : super(key: key);

  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildTasks = ref.watch(buildTasksProvider);
    return SettingWrapper(
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView(
            controller: _controller,
            children: [for (var t in buildTasks) BuildTaskTile(t)],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:local_notifier/local_notifier.dart';

final buildTasksProvider =
    StateNotifierProvider<BuildTasksNotifier, List<BuildTask>>(
        (ref) => BuildTasksNotifier(ref));

class BuildTasksNotifier extends StateNotifier<List<BuildTask>> {
  BuildTasksNotifier(ref) : super(HiveBox.getBuildTasks()) {
    startTimer();
  }

  late Timer timer;
  void add(BuildTask task) {
    state = [task, ...state];
    save();
  }

  void remove(BuildTask task) {
    state = [
      for (var t in state)
        if (t != task) t
    ];
    save();
  }

  void refresh() {
    state = HiveBox.getBuildTasks();
  }

  void update(BuildTask task) {
    state = [
      for (var t in state)
        if (t != task) t else task
    ];
    save();
  }

  void save() {
    HiveBox.saveBuildTasks(state);
  }

  void tick(_) async {
    state = [
      for (var t in state)
        if (t.status == TaskStatus.running) await _updateTaskStatus(t) else t
    ];
    save();
  }

  Future<BuildTask> _updateTaskStatus(BuildTask t) async {
    try {
      final result =
          await JenkinsApi.buildDetail('${t.branchUrl}${t.buildNumber}/');
      TaskStatus? status;
      if (t.status == TaskStatus.running) {
        if (result.result == 'RUNNING') {
          return t;
        }
        if (result.result == 'ABORTED') {
          status = TaskStatus.cancel;
        } else if (result.result == 'FAILURE') {
          status = TaskStatus.fail;
        } else if (result.result == 'SUCCESS') {
          status = TaskStatus.success;
        }
        final notification = LocalNotification(
          title: t.name,
          subtitle: result.result,
          silent: false,
        );
        final localNotifier = LocalNotifier.instance..setAppName('Jenkins Board');
        await localNotifier.notify(notification);
      }
      final task = t.copyWith(
        status: status,
      );
      return task;
    } catch (e) {
      return t;
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), tick);
  }

  void stopTimer() {
    timer.cancel();
  }
}

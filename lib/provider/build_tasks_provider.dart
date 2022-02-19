import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/api/jenkins_api.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/storage/hive_box.dart';

final buildTasksProvider =
    StateNotifierProvider<BuildTasksNotifier, List<BuildTask>>(
        (ref) => BuildTasksNotifier());

class BuildTasksNotifier extends StateNotifier<List<BuildTask>> {
  BuildTasksNotifier() : super(HiveBox.getBuildTasks()) {
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
    for (var t in state) {
      if (t.status == TaskStatus.running) {
        final result = await JenkinsApi.getQueueItem(t.buildUrl);
        TaskStatus? status;
        log(result.toJson());
        if (!result.buildable) {
          if (result.cancelled) {
            status = TaskStatus.cancel;
          } else if (result.color == 'red') {
            status = TaskStatus.fail;
          } else {
            status = TaskStatus.success;
          }
        }
        final task = t.copyWith(
          status: status,
        );
        update(task);
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), tick);
  }

  void stopTimer() {
    timer.cancel();
  }
}

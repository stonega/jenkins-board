import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = [...state, task];
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

  void save() {
    HiveBox.saveBuildTasks(state);
  }

  void tick(_) async {
    for (var t in state) {
      t.running = false;
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), tick);
  }

  void stopTimer() {
    timer.cancel();
  }
}

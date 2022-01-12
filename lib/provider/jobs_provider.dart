import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/model/job.dart';
import 'package:jenkins_board/storage/hive_box.dart';

final jobsProvider =
    StateNotifierProvider<JobsNotifier, List<Job>>((ref) => JobsNotifier());

class JobsNotifier extends StateNotifier<List<Job>> {
  JobsNotifier() : super(HiveBox.getJobs());

  void add(Job job) {
    state = [...state, job];
    save();
  }

  void remove(Job job) {
    state = [
      for (var j in state)
        if (j != job) j
    ];
    save();
  }

  void refresh() {
    state = HiveBox.getJobs();
  }

  void save() {
    HiveBox.saveJobs(state);
  }
}

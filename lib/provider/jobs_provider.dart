import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jenkins_board/model/job.dart';

final jobsProvider =
    StateNotifierProvider<JobsNotifier, List<Job>>((ref) => JobsNotifier());

class JobsNotifier extends StateNotifier<List<Job>> {
  JobsNotifier() : super([]);

  void add(Job job) {
    state = [...state, job];
  }

  void remove(Job job) {
    state = [
      for (var j in state)
        if (j != job) j
    ];
  }
}

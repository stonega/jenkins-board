import 'package:jenkins_board/model/job.dart';

class JobGroup {
  String name;
  String url;
  List<Job> jobs;
  JobGroup({
    required this.name,
    required this.url,
    required this.jobs,
  });
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jenkins_board/model/build_task.dart';
import 'package:jenkins_board/model/job.dart';

const boxKey = 'jenkins_box__key';
const tokenKey = 'token__key';
const authed = 'authed__key';
const baseUrlKey = 'base_url__key';
const jobsKey = 'jobs__key';
const buildTasksKey = 'build_tasks__key';
const usernameKey = 'username__key';

class HiveBox {
  HiveBox._();
  static late Box _box;

  static init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxKey);
  }

  static String getToken() {
    return _box.get(tokenKey, defaultValue: '');
  }

  static saveToken(String token) {
    return _box.put(tokenKey, token);
  }

  static String getUsername() {
    return _box.get(usernameKey, defaultValue: '');
  }

  static saveUsername(String username) {
    return _box.put(usernameKey, username);
  }

  static String getBaseUrl() {
    return _box.get(baseUrlKey, defaultValue: 'https://example.com/');
  }

  static saveBaseUrl(String url) {
    return _box.put(baseUrlKey, url);
  }

  static saveJobs(List<Job> jobs) {
    return _box.put(
      jobsKey,
      jobs.map((j) => j.toJson()).toList(),
    );
  }

  static List<Job> getJobs() {
    final jobs = _box.get(jobsKey, defaultValue: []);
    return [
      for (var j in jobs)
        Job.fromJson(
          Map<String, dynamic>.from(j),
        ),
    ];
  }

  static saveBuildTasks(List<BuildTask> tasks) {
    return _box.put(
      buildTasksKey,
      tasks.map((t) => t.toJson()).toList(),
    );
  }

  static List<BuildTask> getBuildTasks() {
    // _box.put(buildTasksKey, []);
    final tasks = _box.get(buildTasksKey, defaultValue: []);
    return [
      for (var t in tasks)
        BuildTask.fromJson(
          t,
        ),
    ];
  }
}

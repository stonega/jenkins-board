import 'package:hive_flutter/hive_flutter.dart';
import 'package:jenkins_board/model/job.dart';

const boxKey = 'jenkins_box__key';
const tokenKey = 'token__key';
const authed = 'authed__key';
const baseUrlKey = 'base_url__key';
const jobsKey = 'jobs__key';

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

  static String getBaseUrl() {
    return _box.get(baseUrlKey, defaultValue: 'https://cicd.abmatrix.cn/');
  }

  static saveBaseUrl(String url) {
    return _box.put(tokenKey, url);
  }

  static saveJobs(List<Job> jobs) {
    return _box.put(jobsKey, jobs.map((j) => j.toJson()).toList());
  }

  static List<Job> getJobs() {
    final jobs = _box.get(jobsKey, defaultValue: []);
    return [for (var j in jobs) Job.fromJson(Map<String, dynamic>.from(j))];
  }
}

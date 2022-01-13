import 'dart:convert';

import 'package:jenkins_board/api/api_service.dart';
import 'package:jenkins_board/model/branch.dart';
import 'package:jenkins_board/model/job_group.dart';
import 'package:jenkins_board/storage/hive_box.dart';
import 'package:jenkins_board/model/job.dart';

class JenkinsApi {
  static String get token => HiveBox.getToken();
  static String get baseUrl => HiveBox.getBaseUrl();

  static login(String username, String token, String baseUrl) async {
    final authCode = base64Encode('$username:$token'.codeUnits);
    ApiService.setToken(authCode);
    ApiService.setBaseUrl(baseUrl);
    await ApiService.get('/api');
    await HiveBox.saveBaseUrl(baseUrl);
    await HiveBox.saveToken(authCode);
  }

  static Future<List<JobGroup>> getAllJobs() async {
    final res = await ApiService.get('/api/json');
    List<JobGroup> jobGroups = [];
    if (res['jobs'] != null) {
      final jobs = [for (var j in res['jobs']) Job.fromJson(j)];
      for (var j in jobs) {
        final result = await ApiService.get('${j.url}api/json');
        final groupJobs = [for (var j in result['jobs']) Job.fromJson(j)];
        jobGroups.add(JobGroup(name: j.name, url: j.url, jobs: groupJobs));
      }
    }
    return jobGroups;
  }

  static Future<List<Branch>> getJobDetail(Job job) async {
    final res = await ApiService.get('${job.url}api/json');
    List<Branch> branches = [];
    if (res['jobs'] != null) {
      branches = [for (var j in res['jobs']) Branch.fromMap(j)];
    }
    return branches;
  }

  static Future<void> newBuild(Branch branch,
      {Map<String, dynamic>? params}) async {
    final res = await ApiService.postJson('${branch.url}build', params);
    print(res.body);
  }
}

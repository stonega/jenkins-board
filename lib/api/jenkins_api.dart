import 'dart:convert';

import 'package:jenkins_board/api/api_service.dart';
import 'package:jenkins_board/api/models/queue_item.dart';
import 'package:jenkins_board/model/branch.dart';
import 'package:jenkins_board/model/build_result.dart';
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
    final userInfo = await ApiService.get('$baseUrl/user/$username/api/json');
    await HiveBox.saveUsername(userInfo['fullName']);
  }

  static logout() {
    HiveBox.saveToken('');
    HiveBox.saveBaseUrl('');
    HiveBox.saveJobs([]);
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

  static Future<QueueItem> getQueueItem(String url) async {
    final res = await ApiService.get('${url}api/json');
    return QueueItem.fromMap(res);
  }

  static Future<String?> recentBuildUrl(
    String url,
  ) async {
    final res = await ApiService.get('${url}api/json');
    if (res['builds'] != null && res['builds'].isNotEmpty) {
      if (res['builds'][0] != null) {
        return res['builds'][0]['url'];
      }
    }
    return null;
  }

  static Future<String> newBuild(Branch branch,
      {Map<String, dynamic>? params}) async {
    final header = await ApiService.postHeader('${branch.url}build', params);
    return header['localtion'][0];
  }

  static Future<BuildResult> buildDetail(String url) async {
    final result = await ApiService.get('${url}api/json');
    final log = await ApiService.get('${url}consoleText');
    final buildResult = BuildResult.fromMap(result);
    buildResult.consoleLog = log;
    return buildResult;
  }
}

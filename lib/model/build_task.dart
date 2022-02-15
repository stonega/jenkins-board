import 'dart:convert';

import 'package:equatable/equatable.dart';

class BuildTask extends Equatable {
  final String branchName;
  final String branchUrl;
  final String buildUrl;
  final DateTime startTime;
  BuildTask({
    required this.branchName,
    required this.branchUrl,
    required this.buildUrl,
    required this.startTime,
    this.running = true,
  });

  bool running;

  Map<String, dynamic> toMap() {
    return {
      'branchName': branchName,
      'branchUrl': branchUrl,
      'buildUrl': buildUrl,
      'startTime': startTime.millisecondsSinceEpoch
    };
  }

  factory BuildTask.fromMap(Map<String, dynamic> map) {
    return BuildTask(
        branchName: map['branchName'],
        branchUrl: map['branchUrl'],
        buildUrl: map['buildUrl'],
        startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']));
  }

  String toJson() => json.encode(toMap());

  factory BuildTask.fromJson(String source) =>
      BuildTask.fromMap(json.decode(source));

  @override
  List<Object?> get props => ['branchUrl', 'buildUrl'];

  BuildTask copyWith({
    String? branchName,
    String? branchUrl,
    String? buildUrl,
    DateTime? startTime,
    bool? running,
  }) {
    return BuildTask(
      branchName: branchName ?? this.branchName,
      branchUrl: branchUrl ?? this.branchUrl,
      buildUrl: buildUrl ?? this.buildUrl,
      startTime: startTime ?? this.startTime,
      running: running ?? this.running,
    );
  }
}

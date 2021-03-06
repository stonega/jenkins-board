import 'dart:convert';

import 'package:equatable/equatable.dart';

class BuildResult extends Equatable {
  final Duration duration;
  final int id;
  final DateTime timestamp;
  final String displayName;
  final String result;
  final List<String> commits;
  final String? preBuild;
  final String? nextBuild;
  final String? consoleLog;

  const BuildResult(
      {required this.duration,
      required this.id,
      required this.result,
      required this.timestamp,
      required this.displayName,
      required this.commits,
      this.preBuild,
      this.nextBuild,
      this.consoleLog});

  Map<String, dynamic> toMap() {
    return {
      'duration': duration.inSeconds,
      'id': id,
      'timestamp': timestamp,
      'result': result,
      'displayName': displayName,
      'commits': commits,
      'preBuild': preBuild,
      'nextBuild': nextBuild
    };
  }

  factory BuildResult.fromMap(Map<String, dynamic> map) {
    final changeSets = map['changeSets'] as List<dynamic>;
    return BuildResult(
      duration: Duration(seconds: map['duration']),
      id: int.parse(map['id']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      result: map['result'] ?? 'RUNNING',
      displayName: map['displayName'],
      commits: changeSets.isNotEmpty
          ? [for (var i in changeSets[0]['items']) i['msg']]
          : [],
      preBuild:
          map['previousBuild'] != null ? map['previousBuild']['url'] : null,
      nextBuild: map['nextBuild'] != null ? map['nextBuild']['url'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BuildResult.fromJson(String source) =>
      BuildResult.fromMap(json.decode(source));

  @override
  List<Object?> get props => ['userName', 'id', 'duration', 'timestamp'];

  BuildResult copyWith({
    Duration? duration,
    int? id,
    DateTime? timestamp,
    String? displayName,
    String? result,
    List<String>? commits,
    String? preBuild,
    String? nextBuild,
    String? consoleLog,
  }) {
    return BuildResult(
      duration: duration ?? this.duration,
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      displayName: displayName ?? this.displayName,
      result: result ?? this.result,
      commits: commits ?? this.commits,
      preBuild: preBuild ?? this.preBuild,
      nextBuild: nextBuild ?? this.nextBuild,
      consoleLog: consoleLog ?? this.consoleLog,
    );
  }
}

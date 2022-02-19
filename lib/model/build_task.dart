import 'dart:convert';

import 'package:equatable/equatable.dart';

enum TaskStatus { running, fail, success, cancel }

class BuildTask extends Equatable {
  final String name;
  final String branchUrl;
  final String buildUrl;
  final DateTime startTime;
  final DateTime? endTime;
  final TaskStatus status;
  const BuildTask({
    required this.name,
    required this.branchUrl,
    required this.buildUrl,
    required this.startTime,
    this.endTime,
    this.status = TaskStatus.running,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'branchUrl': branchUrl,
      'buildUrl': buildUrl,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'status': status.name
    };
  }

  factory BuildTask.fromMap(Map<String, dynamic> map) {
    return BuildTask(
      name: map['name'],
      branchUrl: map['branchUrl'],
      buildUrl: map['buildUrl'],
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTime'],
      ),
      endTime: map['endTime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              map['endTime'],
            ),
      status: TaskStatus.values.byName(
        map['status'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BuildTask.fromJson(String source) =>
      BuildTask.fromMap(json.decode(source));

  @override
  List<Object?> get props => ['branchUrl', 'buildUrl', 'status'];

  BuildTask copyWith({
    String? name,
    String? branchUrl,
    String? buildUrl,
    DateTime? startTime,
    DateTime? endTime,
    TaskStatus? status,
  }) {
    return BuildTask(
      name: name ?? this.name,
      branchUrl: branchUrl ?? this.branchUrl,
      buildUrl: buildUrl ?? this.buildUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
}

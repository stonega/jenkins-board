// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jenkins_board/model/build_param.dart';

enum BuildStatus {
  aborted,
  aborted_anime,
  notbuilt,
  blue,
  blue_anime,
  red,
  red_anime
}

class Branch {
  final String url;
  final String name;
  final String color;
  final List<BuildParam> buildParams;

  Branch(this.url, this.name, this.color, this.buildParams);

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'name': name,
      'color': color,
    };
  }

  BuildStatus get lastBuild => BuildStatus.values.byName(color);
  Color get statusColor {
    switch (lastBuild) {
      case BuildStatus.aborted:
        return Colors.red;
      case BuildStatus.blue:
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }

  bool get isRunning => lastBuild.name.contains('anime');

  factory Branch.fromMap(Map<String, dynamic> map) {
    // final params = map['property'][1]?['parameterDefinitions'] ?? [];
    return Branch(map['url'], map['name'], map['color'],
        [for (var p in []) BuildParam.fromMap(p)]);
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source));
}

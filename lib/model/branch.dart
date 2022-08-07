// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jenkins_board/model/build_param.dart';

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

  Color get statusColor {
    switch (color) {
      case 'aborted':
        return Colors.red;
      case 'blue':
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }

  bool get isRunning => color.contains('anime');

  factory Branch.fromMap(Map<String, dynamic> map) {
    // final params = map['property'][1]?['parameterDefinitions'] ?? [];
    return Branch(map['url'], map['name'], map['color'],
        [for (var p in []) BuildParam.fromMap(p)]);
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source));
}

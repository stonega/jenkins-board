import 'dart:convert';

class BuildParam<T> {
  String description;
  String name;
  String type;
  T? defautlValue;
  List<String>? choices;
  BuildParam(
      {required this.description,
      required this.name,
      required this.type,
      this.defautlValue,
      this.choices});

  factory BuildParam.fromMap(Map<String, dynamic> map) {
    return BuildParam<T>(
        description: map['description'],
        name: map['name'],
        type: map['type'],
        defautlValue: map['defaultParameterValue']?['value'],
        choices: [for (var c in map['choices'] ?? []) c]);
  }

  factory BuildParam.fromJson(String source) =>
      BuildParam.fromMap(json.decode(source));
}

import 'dart:convert';

class BuildParam<T> {
  String description;
  String name;
  String type;
  T? defautlValue;
  BuildParam({
    required this.description,
    required this.name,
    required this.type,
    this.defautlValue,
  });

  factory BuildParam.fromMap(Map<String, dynamic> map) {
    return BuildParam<T>(
      description: map['description'],
      name: map['name'],
      type: map['type'],
      defautlValue: map['defautlValue']?['defaultParameterValue'],
    );
  }

  factory BuildParam.fromJson(String source) =>
      BuildParam.fromMap(json.decode(source));
}

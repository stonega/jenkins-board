import 'dart:convert';

class QueueItem {
  final bool buildable;
  final bool cancelled;
  final String? why;
  final int id;
  final int inQueueSince;
  final String params;
  final String color;
  QueueItem({
    required this.buildable,
    required this.cancelled,
    this.why,
    required this.id,
    required this.inQueueSince,
    required this.params,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'buildable': buildable,
      'cancelled': cancelled,
      'why': why,
      'id': id,
      'inQueueSince': inQueueSince,
      'params': params,
      'color': color,
    };
  }

  factory QueueItem.fromMap(Map<String, dynamic> map) {
    return QueueItem(
      buildable: map['buildable'],
      cancelled: map['cancelled'] ?? false,
      why: map['why'],
      id: map['id'],
      inQueueSince: map['inQueueSince'],
      params: map['params'],
      color: map['task']['color']
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueItem.fromJson(String source) =>
      QueueItem.fromMap(json.decode(source));
}

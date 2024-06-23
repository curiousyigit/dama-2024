import 'dart:convert';

class WeightEntry {
  String id;
  String userId;
  double kg;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  WeightEntry({
    required this.id,
    required this.userId,
    required this.kg,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WeightEntry.fromJsonStr(String jsonStr) {
    return WeightEntry.fromJson(jsonDecode(jsonStr)['data']);
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        id: json['id'].toString(),
        userId: json['user_id'].toString(),
        kg: double.parse(json['kg'].toString()),
        notes: json['notes'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'kg': kg,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

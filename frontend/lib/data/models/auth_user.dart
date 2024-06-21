import 'package:weight_app/utils.dart';

class AuthUser {
  String id;
  String name;
  String email;
  DateTime? emailVerifiedAt;
  bool isAdmin;
  DateTime createdAt;
  DateTime updatedAt;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'].toString(),
        name: json['name'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'] == null ? null : DateTime.parse(json['email_verified_at']),
        isAdmin: convertToBool(json['is_admin']),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'is_admin': isAdmin,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

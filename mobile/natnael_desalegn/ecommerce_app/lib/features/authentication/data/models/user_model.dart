import '../../../../core/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map)
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final id = (map['_id'] ?? map['id'] ?? '').toString();
    final name = (map['name'] ?? '').toString();
    final email = (map['email'] ?? '').toString();
    // final token = (map['access_token'] ?? map['token'] ?? '').toString();

    return UserModel(
      id: id,
      name: name,
      email: email,
      // token: token.isEmpty ? null : token,
    );
  }
}

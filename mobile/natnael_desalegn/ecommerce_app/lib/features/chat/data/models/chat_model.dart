import '../../../../core/entities/user.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({required super.id, required super.user1, required super.user2});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    User parseUser(Map<String, dynamic> u) =>
        User(id: u['_id'], name: u['name'] ?? '', email: u['email'] ?? '');
    return ChatModel(
      id: json['_id'],
      user1: parseUser(json['user1']),
      user2: parseUser(json['user2']),
    );
  }
}
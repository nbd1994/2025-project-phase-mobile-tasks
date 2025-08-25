import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.content,
    required super.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final chat = json['chat'];
    final sender = json['sender'];
    return MessageModel(
      id: json['_id'],
      chatId: chat is Map ? chat['_id'] : (json['chatId'] ?? ''),
      // senderId: sender is Map ? sender['_id'] : (json['senderId'] ?? ''),
      senderId: sender is Map ? sender['email'] : (json['senderEmail'] ?? ''),
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'content': content,
        'type': type,
      };
}
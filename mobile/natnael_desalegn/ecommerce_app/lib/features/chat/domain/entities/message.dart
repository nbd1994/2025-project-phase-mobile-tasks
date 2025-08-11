class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String type; // 'text' etc.
  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
  });
}
import 'package:dartz/dartz.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Chat>> createChatWithUser(String userId);
  Future<Either<Failure, List<Chat>>> getMyChats();
  Future<Either<Failure, Chat>> getChatById(String chatId);
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);
  Future<Either<Failure, void>> deleteChat(String chatId);
  Future<Either<Failure, List<User>>> getAllUsers();


  // Realtime
  Future<void> connectSocket(String token);
  Future<void> disconnectSocket();
  Stream<Message> subscribeMessages(String chatId);
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    required String senderId,
  });
}
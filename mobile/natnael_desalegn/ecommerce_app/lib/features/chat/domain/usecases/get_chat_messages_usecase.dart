import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessagesUsecase extends UseCase<List<Message>, String> {
  final ChatRepository repo;
  GetChatMessagesUsecase(this.repo);
  @override
  Future<Either<Failure, List<Message>>> call(String chatId) => repo.getChatMessages(chatId);
}
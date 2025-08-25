import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final String type;
  final String senderId;
  SendMessageParams({required this.senderId, required this.chatId, required this.content, this.type = 'text'});
}

class SendMessageUsecase extends UseCase<void, SendMessageParams> {
  final ChatRepository repo;
  SendMessageUsecase(this.repo);
  @override
  Future<Either<Failure, void>> call(SendMessageParams p) =>
      repo.sendMessage(chatId: p.chatId, content: p.content, type: p.type, senderId: p.senderId);
}
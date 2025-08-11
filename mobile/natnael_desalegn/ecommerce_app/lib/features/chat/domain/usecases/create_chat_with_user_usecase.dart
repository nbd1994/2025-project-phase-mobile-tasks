import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class CreateChatWithUserUsecase extends UseCase<Chat, String> {
  final ChatRepository repo;
  CreateChatWithUserUsecase(this.repo);
  @override
  Future<Either<Failure, Chat>> call(String userId) => repo.createChatWithUser(userId);
}
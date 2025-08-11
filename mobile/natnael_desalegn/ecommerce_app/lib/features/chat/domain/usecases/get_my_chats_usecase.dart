import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetMyChatsUsecase extends UseCase<List<Chat>, NoParams> {
  final ChatRepository repo;
  GetMyChatsUsecase(this.repo);
  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) => repo.getMyChats();
}
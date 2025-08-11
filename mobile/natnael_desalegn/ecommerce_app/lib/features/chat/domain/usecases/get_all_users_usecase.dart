import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/entities/user.dart';
import '../repositories/chat_repository.dart';

class GetAllUsersUsecase extends UseCase<List<User>, NoParams> {
  final ChatRepository repo;
  GetAllUsersUsecase(this.repo);
  @override
  Future<Either<Failure, List<User>>> call(NoParams params) => repo.getAllUsers();
}
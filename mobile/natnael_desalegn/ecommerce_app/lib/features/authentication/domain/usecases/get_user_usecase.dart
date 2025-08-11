import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../../../../core/entities/user.dart';
import '../repositories/authentication_repository.dart';

class GetUserUsecase extends UseCase<User, NoParams> {
  final authenticationRepository = sl<AuthenticationRepository>();
  @override
  Future<Either<Failure, User>> call(NoParams params) async{
    return await authenticationRepository.getUser();
  }
}
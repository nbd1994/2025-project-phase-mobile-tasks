import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../repositories/authentication_repository.dart';

class IsLoggedinUsecase extends UseCase<bool, NoParams>{
  final authenticationRepository = sl<AuthenticationRepository>();
  @override
  Future<Either<Failure, bool>> call(NoParams params)async {
    return await authenticationRepository.isLoggedIn();
  }

}
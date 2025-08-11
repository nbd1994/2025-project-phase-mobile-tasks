
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../repositories/authentication_repository.dart';

class LogoutUsecase extends UseCase<void, NoParams>{
  final authenticationRepository = sl<AuthenticationRepository>();

  @override
  Future<Either<Failure,void>>call(NoParams params)async {
    print('usecasecalled');
    return await authenticationRepository.logout();
  }
}
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../../data/models/signin_request_model.dart';
import '../../../../core/entities/user.dart';
import '../repositories/authentication_repository.dart';

class SigninUsecase extends UseCase<User, SigninRequestModel>{
    final authenticationRepository = sl<AuthenticationRepository>();

  @override
  Future<Either<Failure, User>> call(SigninRequestModel params)async {
    return await authenticationRepository.signin(params);
  }
}
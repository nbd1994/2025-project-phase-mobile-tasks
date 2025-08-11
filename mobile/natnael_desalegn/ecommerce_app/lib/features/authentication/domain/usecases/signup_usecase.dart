import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../../data/models/signup_request_model.dart';
import '../../../../core/entities/user.dart';
import '../repositories/authentication_repository.dart';

class SignupUsecase implements UseCase<User, SignupRequestModel>{
  final authenticationRepository = sl<AuthenticationRepository>();
  @override
  Future<Either<Failure, User>> call(SignupRequestModel params) async{
    return await authenticationRepository.signup(params);
  }
}
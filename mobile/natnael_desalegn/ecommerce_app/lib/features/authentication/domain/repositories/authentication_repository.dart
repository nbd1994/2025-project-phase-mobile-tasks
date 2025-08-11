import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/signin_request_model.dart';
import '../../data/models/signup_request_model.dart';
import '../../../../core/entities/user.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> signin(SigninRequestModel signinRequest);
  Future<Either<Failure, User>> signup(SignupRequestModel signupRequest);
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, void>> logout();
}
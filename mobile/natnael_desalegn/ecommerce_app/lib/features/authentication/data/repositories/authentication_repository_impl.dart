import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../injection_container.dart';
import '../../../../core/entities/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/auth_api_service.dart';
import '../datasources/auth_local_service.dart';
import '../models/signin_request_model.dart';
import '../models/signup_request_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final authApiService = sl<AuthApiService>();
  final authLocalService = sl<AuthLocalService>();
  @override
  Future<Either<Failure, User>> signin(SigninRequestModel signinRequest) async {
    try {
      final token = await authApiService.signin(signinRequest);
      await authLocalService.storeToken(token);
      final user = await authApiService.getUserData();
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure());
    } on CacheException catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signup(SignupRequestModel signupRequest) async {
    try {
      final user = await authApiService.signup(signupRequest);
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await authLocalService.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await authApiService.getUserData();
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure());
    }
  }
  
  @override
  Future<Either<Failure,void>>logout() async{
    try{
      await authLocalService.logout();
      return const Right(null);
    }on CacheException catch(e){
      return Left(CacheFailure());
    }
  }
}

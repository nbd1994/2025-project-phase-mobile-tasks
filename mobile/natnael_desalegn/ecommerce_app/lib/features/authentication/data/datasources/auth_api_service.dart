import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../core/constants/api_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../injection_container.dart';
import '../models/signin_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';
import 'auth_local_service.dart';

abstract class AuthApiService {
  Future<UserModel> signup(SignupRequestModel singuprequest);
  Future<String> signin(SigninRequestModel signinRequest);
  Future<UserModel> getUserData();
}

class AuthApiServiceImpl implements AuthApiService {
  final dioClient = sl<DioClient>();
  final authLocalService = sl<AuthLocalService>();
  @override
  Future<String> signin(SigninRequestModel signinRequest) async {
    try {
      var response = await dioClient.post(
        '${ApiUrls.baseUrlAuth}/login',
        data: signinRequest.tojson(),
      );
      return response.data['data']['access_token'];
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signup(SignupRequestModel singuprequest) async {
    try {
      var response = await dioClient.post(
        '${ApiUrls.baseUrlAuth}/register',
        data: singuprequest.tojson(),
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      final token = await authLocalService.getToken();
      if (token == '') {
        throw CacheException();
      }
      var response = await dioClient.get(
        ApiUrls.authGetUserUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    } on CacheException catch (e) {
      rethrow;
    }

  }
}

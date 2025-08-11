import 'package:shared_preferences/shared_preferences.dart';

import '../../../../injection_container.dart';

abstract class AuthLocalService {
  Future<bool> isLoggedIn();
  Future<void> storeToken(String token);
  Future<String> getToken();
  Future<void> logout();
}


class AuthLocalServiceImpl implements AuthLocalService{
  final sharedPeferences = sl<SharedPreferences>();
  @override
  Future<bool> isLoggedIn() async{
    final token = sharedPeferences.getString('token');
    if(token == null){
      return false;
    }
    return true;
  }
  
  @override
  Future<void> storeToken(String token) async{
    sharedPeferences.setString('token', token);
  }
  
  @override
  Future<String> getToken() async {
    final token = sharedPeferences.getString('token');
    if(token == null){
      return '';
    }
    return token;
  }
  
  @override
  Future<void> logout()async {
    await sharedPeferences.remove('token');
  }
}
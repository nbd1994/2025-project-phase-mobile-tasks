class SigninRequestModel {
  final String email;
  final String password;

  SigninRequestModel({required this.email, required this.password});

  Map<String, dynamic> tojson(){
    return {
      'email' : email,
      'password' : password
    };
  }
}
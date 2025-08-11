import '../../../../core/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsn){
    return UserModel(id: jsn['id'], name: jsn['name'], email: jsn['email']);
  }
}

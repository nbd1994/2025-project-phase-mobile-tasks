import '../../../../core/entities/user.dart';

abstract class UserDisplayState {}

class UserLoadingState extends UserDisplayState{}

class UserLoadedState extends UserDisplayState{
  final User user;

  UserLoadedState({required this.user});

}

class UserFaildedToLoadState extends UserDisplayState{
  final String errorMessage;

  UserFaildedToLoadState({required this.errorMessage});

}
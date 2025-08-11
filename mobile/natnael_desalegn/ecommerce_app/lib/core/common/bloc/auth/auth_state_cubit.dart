import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/authentication/domain/usecases/is_loggedin_usecase.dart';
import '../../../../injection_container.dart';
import '../../../usecases/usecase.dart';
import 'auth_state.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(AuthInitialState());


void appStarted() async {
  final result = await sl<IsLoggedinUsecase>().call(NoParams());
  result.fold((failure) => {
  }, (isLoggedIn) => {
    if(isLoggedIn){
      print('already logged in 1111111111111111111'),
      emit(AuthAuthenticatedState())
    }else{
      emit(AuthUnAuthenticatedState())
    }
  });
}
}
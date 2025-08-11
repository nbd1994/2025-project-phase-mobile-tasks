import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/get_user_usecase.dart';
import 'user_display_state.dart';

class UserDisplayCubit extends Cubit<UserDisplayState> {
  UserDisplayCubit() : super(UserLoadingState());

  Future<void> displayUser() async {
    final response = await sl<GetUserUsecase>().call(NoParams());
    response.fold(
      (failure) {
        emit(UserFaildedToLoadState(errorMessage: failure.toString()));
      },
      (user) {
        emit(UserLoadedState(user: user));
      },
    );
  }
}

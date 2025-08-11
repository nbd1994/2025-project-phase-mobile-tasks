import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../usecases/usecase.dart';
import 'button_state.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  void execute({dynamic params, required UseCase useCase}) async {
    emit(ButtonLoadingState());
    // Future.delayed(const Duration(seconds:2));
    try {
      final result = await useCase.call(params);
      result.fold(
        (failure) {
          print('logout failed af233333333333333333333333333333333333333');
           emit(ButtonFailureState(errorMessage: failure.toString()));},
        (user){
        print('logout sucessss');
          emit(ButtonSuccessState());},
      );
    } catch (e) {
      print('unhandled 11111111111111111111111111111111111111111 ${e.toString()}');
      emit(
        ButtonFailureState(errorMessage: 'what is happening ${e.toString()}'),
      );
    }
  }
}

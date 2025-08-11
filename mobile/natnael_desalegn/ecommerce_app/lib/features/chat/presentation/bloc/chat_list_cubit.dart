import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/bloc/button/button_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecases/get_my_chats_usecase.dart';

class ChatListCubit extends Cubit<ButtonState> {
  final GetMyChatsUsecase getMyChats;
  List<Chat> chats = [];
  ChatListCubit(this.getMyChats) : super(ButtonInitialState());

  Future<void> load() async {
    emit(ButtonLoadingState());
    final res = await getMyChats(NoParams());
    res.fold(
      (f) => emit(ButtonFailureState(errorMessage: f.toString())),
      (list) { chats = list; emit(ButtonSuccessState()); },
    );
  }
}
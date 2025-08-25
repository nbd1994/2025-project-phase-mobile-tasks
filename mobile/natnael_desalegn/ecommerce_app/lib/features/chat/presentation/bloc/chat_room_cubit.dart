import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/bloc/button/button_state.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_chat_messages_usecase.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatRoomCubit extends Cubit<ButtonState> {
  final GetChatMessagesUsecase getMessages;
  final SendMessageUsecase send;
  final ChatRepository repo;

  final String chatId;
  List<Message> messages = [];
  StreamSubscription<Message>? _sub;

  ChatRoomCubit({
    required this.chatId,
    required this.getMessages,
    required this.send,
    required this.repo,
  }) : super(ButtonInitialState());

  Future<void> init(String token) async {
    emit(ButtonLoadingState());
    await repo.connectSocket(token);
    final res = await getMessages(chatId);
    res.fold(
      (f) => emit(ButtonFailureState(errorMessage: f.toString() ?? 'Failed')),
      (list) {
        messages = list;
        _sub = repo.subscribeMessages(chatId).listen((m) {
          messages = [...messages, m];
          emit(ButtonSuccessState()); // notify UI to rebuild
        });
        emit(ButtonSuccessState());
      },
    );
  }

  Future<void> sendText({required String text, required String senderId}) async {
    final res = await send(SendMessageParams(senderId: senderId, chatId: chatId, content: text));
    res.fold(
      (f){
        print('hereeeeeeeeeeeeee $f');
        emit(ButtonFailureState(errorMessage: f.toString() ?? 'Send failed'));

      },
      (e) {
        print('send text in side cubit but not error maybe here');
      }
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await repo.disconnectSocket();
    return super.close();
  }
}


// ...existing code...
// class ChatRoomCubit extends Cubit<ButtonState> {
//   final String chatId;
//   final GetChatMessagesUsecase getMessages;
//   final SendMessageUsecase send;
//   final ChatRepository repo;

//   final List<dynamic> messages = [];
//   StreamSubscription? _sub;

//   ChatRoomCubit({
//     required this.chatId,
//     required this.getMessages,
//     required this.send,
//     required this.repo,
//   }) : super(ButtonInitialState());

//   Future<void> init(String token) async {
//     emit(ButtonLoadingState());
//     await repo.connectSocket(token); // ensure socket connect through repo/service
//     // initial history
//     final res = await getMessages(chatId);
//     res.fold(
//       (f) => emit(ButtonFailureState(errorMessage: f.toString())),
//       (list) {
//         messages
//           ..clear()
//           ..addAll(list);
//         emit(ButtonSuccessState()); // triggers first rebuild
//       },
//     );
//     // live subscription
//     _sub?.cancel();
//     _sub = repo.subscribeMessages(chatId).listen((msg) {
//       messages.add(msg);
//       emit(ButtonSuccessState()); // notify UI on each incoming
//     });
//   }

//   Future<void> sendText(String text) async {
//     // optimistic append
//     final optimistic = await repo.sendMessage(chatId: chatId, content: text);
//     messages.add(optimistic);
//     emit(ButtonSuccessState());

//     final res = await send(SendMessageParams(chatId: chatId, content: text));
//     res.fold(
//       (f) => emit(ButtonFailureState(errorMessage: f.toString())),
//       (_) => emit(ButtonSuccessState()),
//     );
//   }

//   @override
//   Future<void> close() async {
//     await _sub?.cancel();
//     return super.close();
//   }
// }
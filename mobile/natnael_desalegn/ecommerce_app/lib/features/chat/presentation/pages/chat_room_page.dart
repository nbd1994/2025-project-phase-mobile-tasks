import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../injection_container.dart';
import '../../../authentication/data/datasources/auth_local_service.dart';
import '../../../../core/common/bloc/button/button_state.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/get_chat_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../bloc/chat_room_cubit.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;
  const ChatRoomPage({super.key, required this.chatId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _ctrl = TextEditingController();
  final _listCtrl = ScrollController();

  String? _token;
  String? _myId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final t = await sl<AuthLocalService>().getToken();
    String? me;
    try {
      final payload = JwtDecoder.decode(t);
      me = payload['sub'] as String?;
    } catch (_) {
      me = null;
    }
    if (!mounted) return;
    setState(() {
      _token = t;
      _myId = me;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (!_listCtrl.hasClients) return;
    // schedule after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listCtrl.hasClients) return;
      _listCtrl.animateTo(
        _listCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final token = _token ?? '';
    return BlocProvider(
      create: (_) => ChatRoomCubit(
        chatId: widget.chatId,
        getMessages: sl<GetChatMessagesUsecase>(),
        send: sl<SendMessageUsecase>(),
        repo: sl<ChatRepository>(),
      )..init(token),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: BlocListener<ChatRoomCubit, ButtonState>(
          listener: (context, state) {
            // Debug prints to verify state flow
            // ignore: avoid_print
            print('[ChatRoomPage] state: ${state.runtimeType}');
            if (state is ButtonFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Failed')),
              );
            }
            if (state is ButtonSuccessState) {
              _scrollToEnd();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatRoomCubit, ButtonState>(
                  builder: (context, _) {
                    final cubit = context.watch<ChatRoomCubit>();
                    final items = cubit.messages;
                    // Debug
                    // ignore: avoid_print
                    print('[ChatRoomPage] messages: ${items.length}');
                    if (items.isEmpty) {
                      return const Center(child: Text('No messages yet'));
                    }
                    return ListView.builder(
                      controller: _listCtrl,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final m = items[i];
                        final isMine = _myId != null && m.senderId == _myId;
                        return Align(
                          alignment:
                              isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? const Color(0xFFDCFCE7) // green-ish
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isMine
                                    ? const Radius.circular(12)
                                    : const Radius.circular(2),
                                bottomRight: isMine
                                    ? const Radius.circular(2)
                                    : const Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              m.content,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Builder(
                        builder: (ctx) => IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF007AFF),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            final text = _ctrl.text.trim();
                            if (text.isEmpty) return;
                            // Debug
                            // ignore: avoid_print
                            print('[ChatRoomPage] send tapped: "$text"');
                            ctx.read<ChatRoomCubit>().sendText(text);
                            _ctrl.clear();
                            _scrollToEnd();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
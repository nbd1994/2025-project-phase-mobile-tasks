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
  String? _myId; // your user id or email (whatever m.senderId matches)
  bool _loading = true;

  // Optimistic pending bubbles (UI-only; not part of domain messages)
  final List<_PendingMsg> _pending = [];

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
      // If your backend uses id in senderId, replace this with your stored user id
      // e.g., me = await sl<AuthenticationRepository>().getUserId();
      me = payload['email'] as String?;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listCtrl.hasClients) return;
      _listCtrl.animateTo(
        _listCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  // Adds a UI-only pending bubble
  void _addPending(String text) {
    final tempId = 'tmp_${DateTime.now().microsecondsSinceEpoch}';
    setState(() {
      _pending.add(_PendingMsg(id: tempId, text: text));
    });
    _scrollToEnd();
  }

  // Remove any pending bubble that matches an echoed server message from me
  void _reconcilePendingWith(List<dynamic> items) {
    if (_myId == null || _pending.isEmpty) return;
    // Try to remove the first pending that matches content + my senderId
    bool removed = false;
    for (final m in items) {
      try {
        final sameAuthor = m.senderId == _myId;
        if (!sameAuthor) continue;
        final idx = _pending.indexWhere((p) => p.text == m.content);
        if (idx != -1) {
          _pending.removeAt(idx);
          removed = true;
          break;
        }
      } catch (_) {
        // ignore items without expected fields
      }
    }
    if (removed && mounted) {
      setState(() {});
    }
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
            // ignore: avoid_print
            print('[ChatRoomPage] state: ${state.runtimeType}');
            if (state is ButtonFailureState) {
              // On failure, remove the last pending bubble as a simple rollback
              if (_pending.isNotEmpty) {
                setState(() {
                  _pending.removeLast();
                });
              }
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
                    // Keep pending list in sync (remove pending that was echoed by server)
                    _reconcilePendingWith(items);

                    // Combined count: real messages + pending bubbles
                    final total = items.length + _pending.length;

                    if (total == 0) {
                      return const Center(child: Text('No messages yet'));
                    }

                    return ListView.builder(
                      controller: _listCtrl,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      itemCount: total,
                      itemBuilder: (_, i) {
                        final isReal = i < items.length;

                        if (isReal) {
                          final m = items[i];
                          final isMine = _myId != null && m.senderId == _myId;
                          return Align(
                            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? const Color(0xFFDCFCE7) // mine
                                    : Colors.grey.shade200, // theirs
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
                        }

                        // Pending bubble (UI-only, always aligned to me)
                        final p = _pending[i - items.length];
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7).withOpacity(0.75),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    p.text,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ],
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
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                            if (text.isEmpty || _myId == null) return;
                            // Log + optimistic bubble
                            print('[ChatRoomPage] send tapped: "$text"');
                            _addPending(text);
                            // Trigger actual send
                            ctx
                                .read<ChatRoomCubit>()
                                .sendText(text: text, senderId: _myId!);
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

// UI-only pending message
class _PendingMsg {
  final String id;
  final String text;
  _PendingMsg({required this.id, required this.text});
}
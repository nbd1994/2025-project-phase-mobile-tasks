import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/chat.dart';
import '../bloc/chat_list_cubit.dart';
import '../../../authentication/data/datasources/auth_local_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  String? _myId;

  @override
  void initState() {
    super.initState();
    _loadMyId();
  }

  Future<void> _loadMyId() async {
    try {
      final token = await sl<AuthLocalService>().getToken();
      if (token.isNotEmpty) {
        final payload = JwtDecoder.decode(token);
        setState(() => _myId = payload['email'] as String?);
      }
    } catch (_) {
      // ignore: token decode failures fall back to null
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatListCubit(sl())..load(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Chats')),
            body: BlocBuilder<ChatListCubit, Object?>(
              builder: (context, state) {
                final cubit = context.watch<ChatListCubit>();
                final chats = cubit.chats;

                final isLoading =
                    state == null || state.toString().toLowerCase().contains('loading');

                if (isLoading && chats.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (chats.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async => context.read<ChatListCubit>().load(),
                    child: ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('No chats yet')),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => context.read<ChatListCubit>().load(),
                  child: ListView.separated(
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final Chat c = chats[i];

                      // Determine "other" participant using myId
                      final other = (_myId != null && _myId!.isNotEmpty)
                          ? (c.user1.email == _myId ? c.user2 : c.user1)
                          : c.user1;

                      return ListTile(
                        leading: _InitialsAvatar(name: other.name),
                        title: Text(other.name),
                        subtitle: Text(other.email),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/chat-room',
                          arguments: c.id,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;
  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final colors = [
      Colors.blue, Colors.teal, Colors.purple, Colors.orange, Colors.green
    ];
    final color = colors[(letter.codeUnitAt(0)) % colors.length];
    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        letter,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
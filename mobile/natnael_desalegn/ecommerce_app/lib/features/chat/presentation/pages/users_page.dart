import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/entities/user.dart';
import '../../../authentication/data/datasources/auth_local_service.dart';
import '../../domain/usecases/create_chat_with_user_usecase.dart';
import '../../domain/usecases/get_all_users_usecase.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _searchCtrl = TextEditingController();
  List<User> _allUsers = [];
  List<User> _filtered = [];
  String? myId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final token = await sl<AuthLocalService>().getToken();
      if (token.isNotEmpty) {
        final payload = JwtDecoder.decode(token);
        myId = payload['sub'] as String?;
      }
      final res = await sl<GetAllUsersUsecase>().call(NoParams());
      res.fold(
        (f) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.toString())));
          setState(() {
            _allUsers = [];
            _filtered = [];
            _loading = false;
          });
        },
        (list) {
          final cleaned =
              myId == null ? list : list.where((u) => u.id != myId).toList();
          setState(() {
            _allUsers = cleaned;
            _filtered = _applyFilter(cleaned, _searchCtrl.text);
            _loading = false;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load users: $e')));
      setState(() => _loading = false);
    }
  }

  List<User> _applyFilter(List<User> source, String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return List<User>.from(source);
    return source.where((u) {
      return u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query);
    }).toList();
  }

  void _onSearchChanged() {
    setState(() {
      _filtered = _applyFilter(_allUsers, _searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start a chat'),
        actions: [
          IconButton(
            tooltip: 'My Chats',
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, '/chats'),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchCtrl.text.isEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _load,
                child:
                    _filtered.isEmpty
                        ? ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('No users found')),
                          ],
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final u = _filtered[i];
                            return ListTile(
                              leading: _InitialsAvatar(name: u.name),
                              title: Text(u.name),
                              subtitle: Text(u.email),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                final res =
                                    await sl<CreateChatWithUserUsecase>().call(
                                      u.id,
                                    );
                                res.fold(
                                  (f) => ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(content: Text(f.toString())),
                                  ),
                                  (chat) {
                                    Navigator.pushNamed(
                                      context,
                                      '/chat-room',
                                      arguments: chat.id,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
              ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;
  const _InitialsAvatar({required this.name});

  Color _colorFromName(String s) {
    final palettes = <Color>[
      const Color(0xFF3B82F6), // blue
      const Color(0xFF14B8A6), // teal
      const Color(0xFF8B5CF6), // purple
      const Color(0xFFF59E0B), // amber
      const Color(0xFF22C55E), // green
      const Color(0xFFEF4444), // red
    ];
    final code = s.isEmpty ? 0 : s.codeUnits.fold<int>(0, (p, c) => p + c);
    return palettes[code % palettes.length];
  }

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final color = _colorFromName(name);
    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

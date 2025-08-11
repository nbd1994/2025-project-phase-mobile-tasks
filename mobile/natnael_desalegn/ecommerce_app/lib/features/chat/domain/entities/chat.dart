import '../../../../core/entities/user.dart';

class Chat {
  final String id;
  final User user1;
  final User user2;
  Chat({required this.id, required this.user1, required this.user2});
}
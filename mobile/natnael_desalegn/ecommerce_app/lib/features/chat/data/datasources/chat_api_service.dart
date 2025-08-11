import 'package:dio/dio.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/chat.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../../authentication/data/datasources/auth_local_service.dart'; // <-- add

abstract class ChatApiService {
  Future<Chat> createChat(String userId);
  Future<List<Chat>> myChats();
  Future<Chat> chatById(String chatId);
  Future<List<MessageModel>> chatMessages(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<User>> getAllUsers();
}

class ChatApiServiceImpl implements ChatApiService {
  final dio = sl<DioClient>();
  final authLocal = sl<AuthLocalService>(); // <-- add

  Future<Options> _authOptions() async {
    final token = await authLocal.getToken();
    if (token.isEmpty) {
      print('Missing auth token');
      throw ServerException();
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<Chat> createChat(String userId) async {
    try {
      final options = await _authOptions();
      final res = await dio.post(
        ApiUrls.baseUrlChat,
        data: {'userId': userId},
        options: options,
      );
      return ChatModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      print('create chat failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<List<Chat>> myChats() async {
    try {
      final options = await _authOptions();
      final res = await dio.get(ApiUrls.baseUrlChat, options: options);
      final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
      return list.map(ChatModel.fromJson).toList();
    } on DioException catch (e) {
      print('Fetch my chats failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<Chat> chatById(String chatId) async {
    try {
      final options = await _authOptions();
      final url = '${ApiUrls.baseUrlChat}/$chatId'; // concat id
      final res = await dio.get(url, options: options);
      return ChatModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      print('Fetch chat failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> chatMessages(String chatId) async {
    try {
      final options = await _authOptions();
      final url = '${ApiUrls.baseUrlChat}/$chatId/messages'; // concat id
      final res = await dio.get(url, options: options);
      final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
      return list.map(MessageModel.fromJson).toList();
    } on DioException catch (e) {
      print('Fetch messages failed: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      final options = await _authOptions();
      final url = '${ApiUrls.baseUrlChat}/$chatId'; // concat id
      await dio.delete(url, options: options);
    } on DioException catch (e) {
      print('Delete chat failed: ${e.message}');
      throw ServerException();
    }
  }


    @override
  Future<List<User>> getAllUsers() async {
    try {
      final res = await dio.get(ApiUrls.chatUsers, options: await _authOptions());
      final data = (res.data['data'] as List).cast<Map<String, dynamic>>();
      return data.map((u) => User(
        id: u['_id'] ?? '',
        name: u['name'] ?? '',
        email: u['email'] ?? '',
      )).toList();
    } on DioException catch (e) {
      print('getAllUsers failed: ${e.message}');
      throw ServerException();
    }
  }
}
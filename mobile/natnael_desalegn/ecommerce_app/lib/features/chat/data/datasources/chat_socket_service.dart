import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../core/constants/api_urls.dart';
import '../models/message_model.dart';

abstract class ChatSocketService {
  Future<void> connect(String token);
  Future<void> disconnect();
  Stream<MessageModel> subscribeMessages(String chatId);
  Future<void> sendMessage(MessageModel message);
}

// class ChatSocketServiceImpl implements ChatSocketService {
//   io.Socket? _socket;
//   final _controllers = <String, StreamController<MessageModel>>{};

//   @override
//   Future<void> connect(String token) async {
//     print('[ChatSocketService] connect called with token: $token');
//     if (_socket != null && _socket!.connected) {
//       print('[ChatSocketService] Already connected');
//       return;
//     }

//     _socket = io.io(
//       ApiUrls.socketBase,
//       io.OptionBuilder()
//           .setTransports(['websocket'])
//           .setExtraHeaders({'token': token})
//           .build(),
//     );

//     final c = Completer<void>();
//     _socket!.onConnect((_) {
//       print('[ChatSocketService] Socket connected');
//       c.complete();
//     });
//     _socket!.onConnectError((e) {
//       print('[ChatSocketService] Socket connect error: $e');
//       c.completeError(e);
//     });
//     _socket!.onError((e) {
//       print('[ChatSocketService] Socket error: $e');
//       c.completeError(e);
//     });

//     _socket!.on('message:received', (data) {
//       print('[ChatSocketService] message:received event: $data');
//       final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
//       final chatId = msg.chatId;
//       if (_controllers.containsKey(chatId)) {
//         print('[ChatSocketService] Adding message to stream for chatId: $chatId');
//         _controllers[chatId]!.add(msg);
//       }
//     });

//     await c.future;
//   }

//   @override
//   Future<void> disconnect() async {
//     print('[ChatSocketService] disconnect called');
//     for (final c in _controllers.values) {
//       await c.close();
//     }
//     _controllers.clear();
//     _socket?.dispose();
//     _socket = null;
//     print('[ChatSocketService] Socket disconnected and resources cleaned up');
//   }

//   @override
//   Stream<MessageModel> subscribeMessages(String chatId) {
//     print('[ChatSocketService] subscribeMessages called for chatId: $chatId');
//     _controllers.putIfAbsent(chatId, () => StreamController<MessageModel>.broadcast());
//     _socket?.emit('chat:join', {'chatId': chatId});
//     print('[ChatSocketService] chat:join emitted for chatId: $chatId');
//     return _controllers[chatId]!.stream;
//   }

//   @override
//   Future<void> sendMessage(MessageModel message) async {
//     print('[ChatSocketService] sendMessage called: ${message.toJson()}');
//     _socket?.emit('message:send', message.toJson());
//     print('[ChatSocketService] message:send emitted');
//   }
//   }

// import 'dart:async';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import '../models/message_model.dart';
// import '../../features/chats/data/models/message_model.dart';

class ChatSocketServiceImpl implements ChatSocketService {
  void Function(Map<String, dynamic>)? onTyping;
  void Function(Map<String, dynamic>)? onStopTyping;
  static const String serverUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com';
  IO.Socket? _socket;
  final _controllers = <String, StreamController<MessageModel>>{};

  // Callbacks
  void Function(MessageModel)? onMessageReceived;
  void Function(MessageModel)? onMessageDelivered;
  void Function(String)? onMessageError;
  void Function()? onConnected;
  void Function()? onDisconnected;

  Future<void> connect(String token) async {
  if (token.isEmpty) throw Exception('No token provided');

  _socket = IO.io(
    serverUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .build(),
  );

  // Now _socket is not null, so you can safely set event listeners
  _socket!.on('userTyping', (data) {
    if (onTyping != null) {
      onTyping!(Map<String, dynamic>.from(data));
    }
  });
  _socket!.on('userStoppedTyping', (data) {
    if (onStopTyping != null) {
      onStopTyping!(Map<String, dynamic>.from(data));
    }
  });

  _socket!.onConnect((_) {
    onConnected?.call();
    print('WebSocket connected');
  });

  _socket!.onDisconnect((_) {
    onDisconnected?.call();
    print('WebSocket disconnected');
  });

  _socket!.on('message:received', (data) {
  try {
    final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
    onMessageReceived?.call(msg);
  } catch (e) {
    print('Error parsing message: $e');
    print('Raw data: $data');
  }
});

  _socket!.on('message:delivered', (data) {
    try {
      final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
      onMessageDelivered?.call(msg);
    } catch (e) {
      print('parse error delivered: $e');
    }
  });

  _socket!.on('message:error', (data) {
    final error = (data is Map && data['error'] != null)
        ? data['error'].toString()
        : 'Unknown error';
    onMessageError?.call(error);
  });
}

  @override
  Stream<MessageModel> subscribeMessages(String chatId) {
    print('[ChatSocketService] subscribeMessages called for chatId: $chatId');
    _controllers.putIfAbsent(chatId, () => StreamController<MessageModel>.broadcast());
    _socket?.emit('chat:join', {'chatId': chatId});
    print('[ChatSocketService] chat:join emitted for chatId: $chatId');
    return _controllers[chatId]!.stream;
  }

  Future<void> sendMessage(MessageModel message)async {
    if (_socket?.connected == true) {
      _socket!.emit('message:send', message.toJson());
    } else {
      onMessageError?.call('Socket not connected');
    }
  }

  void joinChat(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('chat:join', {'chatId': chatId});
    }
  }

  Future<void> disconnect() async{
    _socket?.disconnect();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;

  void emitTyping(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('typing', {'chatId': chatId});
    }
  }

  void emitStopTyping(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('stopTyping', {'chatId': chatId});
    }
  }
}

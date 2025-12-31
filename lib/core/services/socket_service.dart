import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket _socket;
  bool _isInitialized = false;
  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<List<String>> _onlineUsersStreamController =
      StreamController<List<String>>.broadcast();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  Stream<List<String>> get onlineUsersStream =>
      _onlineUsersStreamController.stream;

  bool get isConnected => _isInitialized && _socket.connected;

  void initSocket({required String userId, required String token}) {
    if (_isInitialized) {
      if (!_socket.connected) {
        _socket.connect();
      }
      return;
    }

    _socket = IO.io(
      'https://message-app-backend-wjqq.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableForceNew()
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setQuery({'userId': userId})
          .build(),
    );

    _socket.onConnect((_) {
      print('Socket connected: ${_socket.id}');
      _socket.emit('getOnlineUsers');
    });

    _socket.on('getOnlineUsers', (data) {
      print('Online users received: $data, type: ${data.runtimeType}');
      try {
        List<String> users = [];

        if (data is List) {
          users = List<String>.from(data);
        } else if (data is Map<String, dynamic>) {
          if (data.containsKey('onlineUsers') && data['onlineUsers'] is List) {
            users = List<String>.from(data['onlineUsers']);
          }
        }

        print('Emitting online users: $users');
        if (users.isNotEmpty) {
          _onlineUsersStreamController.add(users);
        }
      } catch (e) {
        print('Error processing online users: $e');
      }
    });

    _socket.on('newMessage', (data) {
      print('New message received: $data');
      if (data is Map<String, dynamic>) {
        _messageStreamController.add(data);
      }
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket.onError((error) {
      print('Socket error: $error');
    });

    _socket.onConnectError((error) {
      print('Socket connection error: $error');
    });

    _isInitialized = true;
  }

  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
      print('Socket manually disconnected');
    }
  }

  void requestOnlineUsers() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isInitialized && _socket.connected) {
        print('Requesting online users from server');
        _socket.emit('getOnlineUsers');
      }
    });
  }

  void connect() {
    if (!_socket.connected) {
      _socket.connect();
      print('Socket manually connected');
    }
  }

  void dispose() {
    disconnect();
    _messageStreamController.close();
    _onlineUsersStreamController.close();
  }
}

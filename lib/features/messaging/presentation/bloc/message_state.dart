import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';

abstract class MessageState {
  List<UserEntity> get cachedUsers => const [];
  List<String> get onlineUserIds => const [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {
  final List<UserEntity> previousUsers;
  final List<String> onlineUsers;

  MessageLoading({this.previousUsers = const [], this.onlineUsers = const []});

  @override
  List<UserEntity> get cachedUsers => previousUsers;

  @override
  List<String> get onlineUserIds => onlineUsers;
}

class UsersLoaded extends MessageState {
  final List<UserEntity> users;
  final List<String> onlineUsers;

  UsersLoaded(this.users, {this.onlineUsers = const []});

  @override
  List<UserEntity> get cachedUsers => users;

  @override
  List<String> get onlineUserIds => onlineUsers;
}

class MessagesLoaded extends MessageState {
  final List<MessageEntity> messages;
  final UserEntity selectedUser;
  final List<UserEntity> cachedUsersList;
  final List<String> onlineUsers;

  MessagesLoaded(
    this.messages,
    this.selectedUser,
    this.cachedUsersList, {
    this.onlineUsers = const [],
  });

  @override
  List<UserEntity> get cachedUsers => cachedUsersList;

  @override
  List<String> get onlineUserIds => onlineUsers;
}

class MessageSent extends MessageState {
  final MessageEntity message;
  final List<UserEntity> cachedUsersList;
  final List<String> onlineUsers;

  MessageSent(
    this.message,
    this.cachedUsersList, {
    this.onlineUsers = const [],
  });

  @override
  List<UserEntity> get cachedUsers => cachedUsersList;

  @override
  List<String> get onlineUserIds => onlineUsers;
}

class MessageError extends MessageState {
  final String message;
  final List<UserEntity> cachedUsersList;
  final List<String> onlineUsers;

  MessageError(
    this.message, {
    this.cachedUsersList = const [],
    this.onlineUsers = const [],
  });

  @override
  List<UserEntity> get cachedUsers => cachedUsersList;

  @override
  List<String> get onlineUserIds => onlineUsers;
}

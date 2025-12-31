import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';

abstract class MessageEvent {}

class LoadUsersEvent extends MessageEvent {}

class LoadMessagesEvent extends MessageEvent {
  final String userId;
  LoadMessagesEvent(this.userId);
}

class SendMessageEvent extends MessageEvent {
  final String receiverId;
  final String message;
  SendMessageEvent(this.receiverId, this.message);
}

class SelectUserEvent extends MessageEvent {
  final UserEntity user;
  SelectUserEvent(this.user);
}

class BackToUsersListEvent extends MessageEvent {}

class InitializeSocketEvent extends MessageEvent {
  final String userId;
  InitializeSocketEvent(this.userId);
}

class NewMessageReceivedEvent extends MessageEvent {
  final MessageEntity message;
  NewMessageReceivedEvent(this.message);
}

class OnlineUsersUpdatedEvent extends MessageEvent {
  final List<String> onlineUserIds;
  OnlineUsersUpdatedEvent(this.onlineUserIds);
}

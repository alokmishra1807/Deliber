import 'package:deliber/core/services/socket_service.dart';
import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';
import 'package:deliber/features/messaging/domain/usecases/get_messages_usecase.dart';
import 'package:deliber/features/messaging/domain/usecases/get_users_usecase.dart';
import 'package:deliber/features/messaging/domain/usecases/send_message_usecase.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_event.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetUsersUseCase getUsersUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final SocketService socketService;

  UserEntity? _selectedUser;
  List<UserEntity> _cachedUsers = [];
  List<String> _onlineUserIds = [];
  bool _socketListenersInitialized = false;

  MessageBloc({
    required this.getUsersUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.socketService,
  }) : super(MessageInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<SelectUserEvent>(_onSelectUser);
    on<BackToUsersListEvent>(_onBackToUsersList);
    on<InitializeSocketEvent>(_onInitializeSocket);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<OnlineUsersUpdatedEvent>(_onOnlineUsersUpdated);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(
      MessageLoading(previousUsers: _cachedUsers, onlineUsers: _onlineUserIds),
    );
    final result = await getUsersUseCase();

    result.fold(
      (failure) => emit(
        MessageError(
          failure.message,
          cachedUsersList: _cachedUsers,
          onlineUsers: _onlineUserIds,
        ),
      ),
      (users) {
        _cachedUsers = users;
        emit(UsersLoaded(users, onlineUsers: _onlineUserIds));
      },
    );
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    if (_selectedUser == null) {
      emit(
        MessageError(
          'No user selected',
          cachedUsersList: _cachedUsers,
          onlineUsers: _onlineUserIds,
        ),
      );
      return;
    }

    if (state is! MessagesLoaded) {
      emit(
        MessageLoading(
          previousUsers: _cachedUsers,
          onlineUsers: _onlineUserIds,
        ),
      );
    }

    final result = await getMessagesUseCase(userId: event.userId);

    result.fold(
      (failure) => emit(
        MessageError(
          failure.message,
          cachedUsersList: _cachedUsers,
          onlineUsers: _onlineUserIds,
        ),
      ),
      (messages) => emit(
        MessagesLoaded(
          messages,
          _selectedUser!,
          _cachedUsers,
          onlineUsers: _onlineUserIds,
        ),
      ),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final result = await sendMessageUseCase(
      receiverId: event.receiverId,
      message: event.message,
    );

    result.fold(
      (failure) => emit(
        MessageError(
          failure.message,
          cachedUsersList: _cachedUsers,
          onlineUsers: _onlineUserIds,
        ),
      ),
      (message) {
        add(LoadMessagesEvent(event.receiverId));
      },
    );
  }

  void _onSelectUser(SelectUserEvent event, Emitter<MessageState> emit) {
    _selectedUser = event.user;
    add(LoadMessagesEvent(event.user.id));
  }

  void _onBackToUsersList(
    BackToUsersListEvent event,
    Emitter<MessageState> emit,
  ) {
    if (_cachedUsers.isNotEmpty) {
      emit(UsersLoaded(_cachedUsers, onlineUsers: _onlineUserIds));
    } else {
      add(LoadUsersEvent());
    }
  }

  void _onInitializeSocket(
    InitializeSocketEvent event,
    Emitter<MessageState> emit,
  ) {
    socketService.initSocket(userId: event.userId, token: '');

    if (_socketListenersInitialized) {
      return;
    }

    _socketListenersInitialized = true;

    Future.delayed(const Duration(milliseconds: 200), () {
      socketService.messageStream.listen((message) {
        final messageEntity = MessageEntity(
          id: (message['_id'] ?? message['id'] ?? '').toString(),
          senderId: (message['senderId'] ?? '').toString(),
          receiverId: (message['recieverId'] ?? message['receiverId'] ?? '')
              .toString(),
          message: (message['message'] ?? '').toString(),
          createdAt: message['createdAt'] != null
              ? DateTime.parse(message['createdAt'].toString())
              : DateTime.now(),
          updatedAt: message['updatedAt'] != null
              ? DateTime.parse(message['updatedAt'].toString())
              : DateTime.now(),
        );
        add(NewMessageReceivedEvent(messageEntity));
      });

      socketService.onlineUsersStream.listen((users) {
        add(OnlineUsersUpdatedEvent(users));
      });

      socketService.requestOnlineUsers();
    });
  }

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    if (state is MessagesLoaded) {
      final currentState = state as MessagesLoaded;
      if (event.message.senderId == _selectedUser?.id ||
          event.message.receiverId == _selectedUser?.id) {
        final updatedMessages = [...currentState.messages, event.message];
        emit(
          MessagesLoaded(
            updatedMessages,
            currentState.selectedUser,
            currentState.cachedUsersList,
            onlineUsers: _onlineUserIds,
          ),
        );
      }
    }
  }

  void _onOnlineUsersUpdated(
    OnlineUsersUpdatedEvent event,
    Emitter<MessageState> emit,
  ) {
    _onlineUserIds = event.onlineUserIds;

    if (state is UsersLoaded) {
      final currentState = state as UsersLoaded;
      emit(UsersLoaded(currentState.cachedUsers, onlineUsers: _onlineUserIds));
    } else if (state is MessagesLoaded) {
      final currentState = state as MessagesLoaded;
      emit(
        MessagesLoaded(
          currentState.messages,
          currentState.selectedUser,
          currentState.cachedUsersList,
          onlineUsers: _onlineUserIds,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    socketService.dispose();
    return super.close();
  }
}

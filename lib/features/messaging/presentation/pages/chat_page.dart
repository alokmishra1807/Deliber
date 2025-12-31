import 'package:deliber/core/design/color_pallette.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_event.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_state.dart';
import 'package:deliber/features/messaging/presentation/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final UserEntity user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(LoadMessagesEvent(widget.user.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    context.read<MessageBloc>().add(
      SendMessageEvent(widget.user.id, _messageController.text.trim()),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<MessageBloc>().add(BackToUsersListEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.gradient1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.read<MessageBloc>().add(BackToUsersListEvent());
              Navigator.pop(context);
            },
          ),
          title: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              final isOnline = state.onlineUserIds.contains(widget.user.id);
              return Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.user.profilePic),
                        backgroundColor: Pallete.gradient2,
                      ),
                      if (isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOnline ? Colors.greenAccent : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<MessageBloc, MessageState>(
                listener: (context, state) {
                  if (state is MessagesLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
                },
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MessageError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MessageBloc>().add(
                                LoadMessagesEvent(widget.user.id),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text('No messages yet. Start the conversation!'),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId != widget.user.id;
                        return MessageBubble(message: message, isMe: isMe);
                      },
                    );
                  }

                  return const Center(child: Text('Start chatting!'));
                },
              ),
            ),
            MessageInput(
              messageController: _messageController,
              onSendPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:deliber/core/design/color_pallette.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_event.dart';
import 'package:deliber/features/messaging/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;
  final bool isOnline;

  const UserTile({super.key, required this.user, this.isOnline = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.profilePic),
            backgroundColor: Pallete.gradient2,
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        isOnline ? 'Online • @${user.username}' : '@${user.username}',
        style: TextStyle(
          color: isOnline ? Colors.green : Colors.grey[600],
          fontSize: 14,
        ),
      ),
      onTap: () {
        context.read<MessageBloc>().add(SelectUserEvent(user));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(user: user)),
        );
      },
    );
  }
}

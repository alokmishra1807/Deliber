import 'package:deliber/core/design/color_pallette.dart';
import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_event.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_state.dart';
import 'package:deliber/features/messaging/presentation/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<MessageBloc>().add(InitializeSocketEvent(authState.auth.id));
    }
    context.read<MessageBloc>().add(LoadUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'We Chat',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 240, 240, 240),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Pallete.gradient1,
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
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
                      context.read<MessageBloc>().add(LoadUsersEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is UsersLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                final isOnline = state.onlineUserIds.contains(user.id);
                return UserTile(user: user, isOnline: isOnline);
              },
            );
          }

          return const Center(child: Text('Start chatting with people!'));
        },
      ),
    );
  }
}

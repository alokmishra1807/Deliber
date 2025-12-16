import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final email = context.select<AuthBloc, String?>(
      (bloc) {
      final state = bloc.state;
      if (state is AuthSuccess) {
        return state.user.email;
      }
      return null;
    },
    );
    return Scaffold(
      body: Center(child: Text(email ?? 'No Email',)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthIsLoggedOut());
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

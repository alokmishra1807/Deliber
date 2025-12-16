import 'package:deliber/features/landing/presentation/bloc/onboarding_bloc.dart';
import 'package:deliber/features/landing/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deliber/init_dependencies.dart';


import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deliber/features/auth/presentation/pages/login.dart';
import 'package:deliber/features/home/presentation/pages/home.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              serviceLocator<AuthBloc>()..add( AuthIsUserLoggedIn()),
        ),
        BlocProvider<OnboardingBloc>(
          create: (_) =>
              serviceLocator<OnboardingBloc>()..add(CheckOnboarding()),
        ),
      ],
      child: MaterialApp(
        title: 'Deliber',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AppGate(),
      ),
    );
  }
}


class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, onboardingState) {
      
        if (onboardingState is OnboardingInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        
        if (onboardingState is OnboardingRequired) {
          return const OnboardingView();
        }

       
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthInitial || authState is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (authState is AuthSuccess) {
              return const Homepage();
            }

            if (authState is AuthUnauthenticated) {
              return const Login();
            }

            if (authState is AuthFailure) {
              return Scaffold(
                body: Center(child: Text(authState.message)),
              );
            }

            return const Login();
          },
        );
      },
    );
  }
}

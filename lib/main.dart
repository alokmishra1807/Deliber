import 'package:deliber/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:deliber/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:deliber/features/location/presentation/bloc/location_bloc.dart';
import 'package:deliber/features/home/presentation/pages/home.dart';
import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deliber/features/auth/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deliber/init_dependencies.dart';

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
        BlocProvider<OnboardingBloc>(
          create: (_) =>
              serviceLocator<OnboardingBloc>()..add(CheckOnboarding()),
        ),
        BlocProvider<LocationBloc>(
          create: (_) => serviceLocator<LocationBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) =>
              serviceLocator<AuthBloc>()..add(const CheckAuthStatusEvent()),
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
        if (onboardingState is OnboardingRequired) {
          return const OnboardingView();
        }

        if (onboardingState is OnboardingInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            
            if (authState is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            
            if (authState is AuthSuccess) {
              return const HomePage();
            }

            
            return const LoginPage();
          },
        );
      },
    );
  }
}

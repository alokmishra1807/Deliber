import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deliber/core/design/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Deliber',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurple.shade700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fast Delivery, Fresh Goods',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple.shade300,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/travel.png'),
                const SizedBox(height: 40),
                Text(
                  'Fast delivery, right at your doorstep',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Order anything you need and get it delivered quickly, safely, and hassle-free.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Begin Your Journey With Us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                StylishButton(
                  text: 'Continue With Google',
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogin());
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:deliber/core/design/color_pallette.dart';
import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deliber/features/auth/presentation/pages/login.dart';
import 'package:deliber/features/auth/presentation/widgets/gradient_button.dart';
import 'package:deliber/features/auth/presentation/widgets/login_field.dart';
import 'package:deliber/features/home/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        SignUpEvent(
          name: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          confirmedPassword: _confirmPasswordController.text,
          gender: _selectedGender,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 240, 240, 240),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Pallete.gradient1,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (_) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Pallete.gradient1,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthField(
                        hintText: 'Full Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: 'Username',
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: 'Password',
                        controller: _passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        isObscureText: true,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGender,
                        onChanged: isLoading
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue ?? 'Male';
                                });
                              },
                        decoration: InputDecoration(
                          hintText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Pallete.gradient1,
                              width: 2,
                            ),
                          ),
                        ),
                        items: ['Male', 'Female']
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: AuthGradientButton(
                          onTap: _handleSignUp,
                          buttonText: 'Sign Up',
                          isLoading: isLoading,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginPage(),
                                    ),
                                  );
                                },
                          child: Text(
                            'Already have an account? Sign in',
                            style: TextStyle(
                              color: Pallete.gradient1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

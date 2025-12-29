part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({required this.username, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String username;
  final String password;
  final String confirmedPassword;
  final String gender;

  const SignUpEvent({
    required this.name,
    required this.username,
    required this.password,
    required this.confirmedPassword,
    required this.gender,
  });
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

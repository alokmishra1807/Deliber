part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthEntity auth;

  const AuthSuccess(this.auth);
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}

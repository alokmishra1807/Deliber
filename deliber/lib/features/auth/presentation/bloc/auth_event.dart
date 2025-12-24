part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

class AuthLogin extends AuthEvent {
  const AuthLogin();
}


final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthIsLoggedOut extends AuthEvent{}
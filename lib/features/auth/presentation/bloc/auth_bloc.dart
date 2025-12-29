import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/login_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin _userLogin;
  final UserSignUp _userSignUp;
  final GetCachedUserUseCase _getCachedUser;

  AuthBloc({
    required UserLogin userLogin,
    required UserSignUp userSignUp,
    required GetCachedUserUseCase getCachedUser,
  }) : _userLogin = userLogin,
       _userSignUp = userSignUp,
       _getCachedUser = getCachedUser,
       super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _userLogin(
      username: event.username,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (auth) => emit(AuthSuccess(auth)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _userSignUp(
      name: event.name,
      username: event.username,
      password: event.password,
      confirmedPassword: event.confirmedPassword,
      gender: event.gender,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (auth) => emit(AuthSuccess(auth)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCachedUser();
    result.fold(
      (failure) => emit(const AuthInitial()),
      (auth) => emit(AuthSuccess(auth)),
    );
  }
}

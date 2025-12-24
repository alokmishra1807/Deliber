import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/usecases/getuser_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/logout_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/sigin_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase _signInUsecase;
  final GetuserUsecase _getuserUsecase;
  final LogoutUsecase _logoutUsecase;

  AuthBloc({
    required SignInUsecase signInusecase,
    required GetuserUsecase getUserusecase,
    required LogoutUsecase logOutusecase,
  }) : _signInUsecase = signInusecase,
       _getuserUsecase = getUserusecase,
       _logoutUsecase = logOutusecase,

       super(AuthInitial()) {
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_onIsUserLoggedIn);
    on<AuthIsLoggedOut>(_onAuthIsLoggedOut);
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _signInUsecase();

    res.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthSuccess(user));
      }
    });
  }

  Future<void> _onIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _getuserUsecase();

    res.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthSuccess(user));
      }
    });
  }

  Future<void> _onAuthIsLoggedOut(
    AuthIsLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _logoutUsecase();

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}

import 'package:deliber/features/landing/domain/usecases/check_onboarding_usecase.dart';
import 'package:deliber/features/landing/domain/usecases/complete_onboarding_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingUsecase _checkOnboardingUsecase;
  final CompleteOnboardingUsecase _completeOnboardingUsecase;

  OnboardingBloc(this._checkOnboardingUsecase, this._completeOnboardingUsecase)
    : super(OnboardingInitial()) {
    on<CheckOnboarding>((event, emit) {
      final done = _checkOnboardingUsecase();
      emit(done ? OnboardingCompleted() : OnboardingRequired());
    },
    
    );
    on<FinishOnboarding>((event, emit)  {
       _completeOnboardingUsecase();
      emit(OnboardingCompleted());
    });
  }
}

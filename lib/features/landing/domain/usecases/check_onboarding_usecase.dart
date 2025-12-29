


import 'package:deliber/features/landing/data/datasources/onboarding_local_sources..dart';

class CheckOnboardingUsecase {
  final OnboardingLocalDataSource datasource;

  CheckOnboardingUsecase(this.datasource);

  bool call() {
    return datasource.isOnboardingCompleted();
  }
}

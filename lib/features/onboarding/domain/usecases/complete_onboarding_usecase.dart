import 'package:deliber/features/onboarding/data/datasources/onboarding_local_sources..dart';

class CompleteOnboardingUsecase {
  final OnboardingLocalDataSource datasource;

  CompleteOnboardingUsecase(this.datasource);

  Future<void> call() async {
    await datasource.completeOnboarding();
  }
}

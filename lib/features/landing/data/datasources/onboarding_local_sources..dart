abstract interface class OnboardingLocalDataSource {
  bool isOnboardingCompleted();
  Future<void> completeOnboarding();
}

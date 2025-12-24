import 'package:deliber/features/landing/data/datasources/onboarding_local_sources..dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSourceImpl
    implements OnboardingLocalDataSource {
  final SharedPreferences prefs;

  OnboardingLocalDataSourceImpl(this.prefs);

  @override
  bool isOnboardingCompleted() {
    return prefs.getBool('onboarding_done') ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await prefs.setBool('onboarding_done', true);
  }
}

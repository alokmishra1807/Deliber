import 'package:deliber/features/auth/data/repository/auth_repository_imp.dart';
import 'package:deliber/features/auth/domain/usecases/getuser_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/logout_usecase.dart';
import 'package:deliber/features/landing/data/datasources/onboarding_local_sources..dart';

import 'package:deliber/features/landing/data/datasources/onboarding_local_sources_imp.dart';
import 'package:deliber/features/landing/domain/usecases/check_onboarding_usecase.dart';
import 'package:deliber/features/landing/domain/usecases/complete_onboarding_usecase.dart';
import 'package:deliber/features/landing/presentation/bloc/onboarding_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:deliber/features/auth/data/datasources/auth_remote_datasouce.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_datasource_impl.dart';

import 'package:deliber/features/auth/domain/repositories/auth_repository.dart';
import 'package:deliber/features/auth/domain/usecases/sigin_usecase.dart';

import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);

  _initAuth();
  _initOnboarding();
}

void _initAuth() {
  serviceLocator.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  serviceLocator.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn.instance,
  );

  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDatasourceImpl(
      firebaseAuth: serviceLocator(),
      googleSignIn: serviceLocator(),
    ),
  );

  /// Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetuserUsecase>(
    () => GetuserUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(serviceLocator()),
  );

  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInusecase: serviceLocator(),
      getUserusecase: serviceLocator(),
      logOutusecase: serviceLocator(),
    ),
  );
}

void _initOnboarding() {
  serviceLocator.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<CheckOnboardingUsecase>(
    () => CheckOnboardingUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<CompleteOnboardingUsecase>(
    () => CompleteOnboardingUsecase(serviceLocator()),
  );

  serviceLocator.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(serviceLocator(), serviceLocator()),
  );
}

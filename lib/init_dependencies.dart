import 'package:deliber/features/auth/data/repository/auth_repository_imp.dart';
import 'package:deliber/features/auth/domain/usecases/getuser_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/logout_usecase.dart';
import 'package:deliber/features/landing/data/datasources/onboarding_local_sources..dart';

import 'package:deliber/features/landing/data/datasources/onboarding_local_sources_imp.dart';
import 'package:deliber/features/landing/domain/usecases/check_onboarding_usecase.dart';
import 'package:deliber/features/landing/domain/usecases/complete_onboarding_usecase.dart';
import 'package:deliber/features/landing/presentation/bloc/onboarding_bloc.dart';
import 'package:deliber/features/location/data/datasources/geo_coding_remote_datasource.dart';
import 'package:deliber/features/location/data/datasources/location_local_datasource.dart';
import 'package:deliber/features/location/data/repository/location_repository_imp.dart';
import 'package:deliber/features/location/domain/repositories/location_repository.dart';

import 'package:deliber/features/location/domain/usecase/get_address.dart';
import 'package:deliber/features/location/domain/usecase/get_location.dart';

import 'package:deliber/features/location/presentation/bloc/location_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:deliber/features/auth/data/datasources/auth_remote_datasouce.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_datasource_impl.dart';

import 'package:deliber/features/auth/domain/repositories/auth_repository.dart';
import 'package:deliber/features/auth/domain/usecases/sigin_usecase.dart';

import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);
 
  _initOnboarding();
  _initAuth();

  _initLocation();
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

void _initLocation() {
  serviceLocator.registerLazySingleton<Location>(
  () => Location(),
);

  /// Data sources
  serviceLocator.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(serviceLocator<Location>()),
  );

  serviceLocator.registerLazySingleton<GeocodingRemoteDataSource>(
    () => GeocodingRemoteDataSourceImpl(),
  );

  /// Repository
  serviceLocator.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImp(
      serviceLocator<GeocodingRemoteDataSource>(),
      serviceLocator<LocationLocalDataSource>(),
    ),
  );

  /// Use cases
  serviceLocator.registerLazySingleton<GetLocationUsecase>(
    () => GetLocationUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetAddressUsecase>(
    () => GetAddressUsecase(serviceLocator()),
  );

  /// Bloc
  serviceLocator.registerFactory<LocationBloc>(
    () => LocationBloc(
      getLocationUsecase: serviceLocator(),
      getAddressUsecase: serviceLocator(),
    ),
  );
}

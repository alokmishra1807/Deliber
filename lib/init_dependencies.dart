import 'package:deliber/features/onboarding/data/datasources/onboarding_local_sources..dart';

import 'package:deliber/features/onboarding/data/datasources/onboarding_local_sources_imp.dart';
import 'package:deliber/features/onboarding/domain/usecases/check_onboarding_usecase.dart';
import 'package:deliber/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:deliber/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:deliber/features/location/data/datasources/geo_coding_remote_datasource.dart';
import 'package:deliber/features/location/data/datasources/location_local_datasource.dart';
import 'package:deliber/features/location/data/repository/location_repository_imp.dart';
import 'package:deliber/features/location/domain/repositories/location_repository.dart';

import 'package:deliber/features/location/domain/usecase/get_address.dart';
import 'package:deliber/features/location/domain/usecase/get_location.dart';

import 'package:deliber/features/location/presentation/bloc/location_bloc.dart';
import 'package:deliber/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_data_source_imp.dart';
import 'package:deliber/features/auth/data/repositories/auth_repo_implement.dart';
import 'package:deliber/features/auth/domain/repository/auth_repository.dart';
import 'package:deliber/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/login_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/signup_usecase.dart';
import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);

  _initAuth();
  _initOnboarding();
  _initLocation();
}

void _initAuth() {
  // Data Sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(http.Client()),
  );

  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<UserLogin>(
    () => UserLogin(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetCachedUserUseCase>(
    () => GetCachedUserUseCase(serviceLocator()),
  );

  // Bloc
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      userLogin: serviceLocator(),
      userSignUp: serviceLocator(),
      getCachedUser: serviceLocator(),
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
  serviceLocator.registerLazySingleton<Location>(() => Location());

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

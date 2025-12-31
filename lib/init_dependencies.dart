import 'package:deliber/core/services/socket_service.dart';
import 'package:deliber/features/onboarding/data/datasources/onboarding_local_sources..dart';

import 'package:deliber/features/onboarding/data/datasources/onboarding_local_sources_imp.dart';
import 'package:deliber/features/onboarding/domain/usecases/check_onboarding_usecase.dart';
import 'package:deliber/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:deliber/features/onboarding/presentation/bloc/onboarding_bloc.dart';


import 'package:deliber/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_data_source_imp.dart';
import 'package:deliber/features/auth/data/repositories/auth_repo_implement.dart';
import 'package:deliber/features/auth/domain/repository/auth_repository.dart';
import 'package:deliber/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/login_usecase.dart';
import 'package:deliber/features/auth/domain/usecases/signup_usecase.dart';
import 'package:deliber/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deliber/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:deliber/features/messaging/data/datasources/message_remote_datasource_impl.dart';
import 'package:deliber/features/messaging/data/repositories/message_repository_impl.dart';
import 'package:deliber/features/messaging/domain/repositories/message_repository.dart';
import 'package:deliber/features/messaging/domain/usecases/get_messages_usecase.dart';
import 'package:deliber/features/messaging/domain/usecases/get_users_usecase.dart';
import 'package:deliber/features/messaging/domain/usecases/send_message_usecase.dart';
import 'package:deliber/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;


import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);

  _initAuth();
  _initOnboarding();
  
  _initMessaging();
}

void _initAuth() {
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(http.Client()),
  );

  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserLogin>(
    () => UserLogin(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetCachedUserUseCase>(
    () => GetCachedUserUseCase(serviceLocator()),
  );

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



void _initMessaging() {
  serviceLocator.registerLazySingleton<SocketService>(() => SocketService());

  serviceLocator.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(http.Client()),
  );

  serviceLocator.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetMessagesUseCase>(
    () => GetMessagesUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory<MessageBloc>(
    () => MessageBloc(
      getUsersUseCase: serviceLocator(),
      getMessagesUseCase: serviceLocator(),
      sendMessageUseCase: serviceLocator(),
      socketService: serviceLocator(),
    ),
  );
}

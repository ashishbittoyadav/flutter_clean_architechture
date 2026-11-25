import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/todos/data/datasources/todo_remote_source.dart';
import 'features/todos/data/repository/todo_repository_impl.dart';
import 'features/todos/domain/repository/todos_repository.dart';
import 'features/todos/domain/usecases/create_to_do_use_case.dart';
import 'features/todos/domain/usecases/delete_to_do_use_case.dart';
import 'features/todos/domain/usecases/fetch_todo_use_case.dart';
import 'features/todos/domain/usecases/update_to_do_use_case.dart';
import 'features/todos/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future init() async{
  sl.registerFactory(()=> AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isAuthenticatedUseCase: sl()));
  sl.registerLazySingleton(()=>LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(()=>LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(()=>GetCurrentUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(()=>IsAuthenticatedUseCase(authRepository: sl()));
  
  sl.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl(
      authRemoteDataSource: sl(), 
      authLocalDataSource: sl()));
  
  sl.registerLazySingleton<AuthRemoteDataSource>(()=>AuthRemoteDataSourceImpl());
  // sl.registerLazySingleton<AuthLocalDataSource>(()=>AuthLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(()=>AuthLocalSecureSourceImpl(flutterSecureStorage: sl(),localAuthentication: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerFactory(()=> TodoBloc(createToDoUseCase: sl(), deleteToDoUseCase: sl(), fetchToDoUseCase: sl(), updateToDoUseCase: sl()));
  sl.registerLazySingleton(()=>CreateToDoUseCase(toDoRepository: sl()));
  sl.registerLazySingleton(()=>DeleteToDoUseCase(todosRepository: sl()));
  sl.registerLazySingleton(()=>FetchTodoUseCase(todosRepository: sl()));
  sl.registerLazySingleton(()=>UpdateToDoUseCase(todosRepository: sl()));
  sl.registerLazySingleton<TodosRepository>(()=>TodoRepositoryImpl(todoRemoteSource: sl()));
  sl.registerLazySingleton<TodoRemoteSource>(()=>TodoRemoteSourceImpl(dio: sl()));


  sl.registerLazySingleton<Dio>(
        () => Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    ),
  );
  sl<Dio>().interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );

  sl.registerLazySingleton<FlutterSecureStorage>(()=>
  FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock
    ),
    aOptions: AndroidOptions(
      enforceBiometrics: true,
      biometricPromptTitle: 'Authenticate Required'
    )
  )
  );

  sl.registerLazySingleton(()=>
    LocalAuthentication()
  );

  // final dio = Dio(
  //   BaseOptions(
  //     baseUrl: "https://dummyjson.com/",
  //     connectTimeout: const Duration(seconds: 30),
  //     receiveTimeout: const Duration(seconds: 30),
  //     headers: {
  //       "Content-Type": "application/json",
  //     }
  //   )
  // );
  //
  // dio.interceptors.add(
  //   LogInterceptor(
  //     requestBody: true,
  //     responseBody: true,
  //
  //   )
  // );

  // sl.registerLazySingleton(() => dio);

}
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_sp.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_inout.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/domain/repositories/login_repository.dart';
import 'package:sp_2021/feature/login/domain/usecases/usecase_login.dart';
import 'package:sp_2021/feature/login/domain/usecases/usecase_logout.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'core/api/myDio.dart';
import 'core/platform/network_info.dart';
import 'feature/attendance/presentation/blocs/map_bloc.dart';
import 'feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'feature/login/data/datasources/login_remote_datasource.dart';
import 'feature/login/data/repositories/login_repository_impl.dart';
import 'feature/login/presentation/blocs/authentication_bloc.dart';
import 'feature/login/presentation/blocs/login_bloc.dart';
import 'feature/receive_gift/data/repositories/receive_gift_repository_impl.dart';

final sl = GetIt.instance;
Future<void> init() async{
  const String apiBaseUrl = 'https://sp.imark.vn/';
  const String apiPath = 'api';
  //! Core
  sl.registerLazySingleton<Dialogs>(() => Dialogs());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  //! External
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    baseUrl: '$apiBaseUrl/$apiPath/',
    connectTimeout: 60000,
    receiveTimeout: 60000,
    responseType: ResponseType.json,
    validateStatus: (status) => true,
    receiveDataWhenStatusError: true,
  ),));
  sl.registerLazySingleton<CDio>(() => CDio(client:sl()));
  sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
  //! Features - Login //
  // Bloc
  sl.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(storage: sl()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(login: sl(), logout: sl(), authenticationBloc: sl()));
  //Use case
  sl.registerLazySingleton<UsecaseLogin>(() => UsecaseLogin(sl()));
  sl.registerLazySingleton<UseCaseLogout>(() => UseCaseLogout());
  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
      remoteDataSource: sl()));
  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(cDio: sl()));
  //! Features - Dashboard
  // Bloc
  sl.registerFactory<DashboardBloc>(() => DashboardBloc());
  sl.registerFactory<TabBloc>(() => TabBloc());
  //! Feature Attendance
  //Bloc
  sl.registerLazySingleton<MapBloc>(() => MapBloc());
  sl.registerFactory<AttendanceBloc>(() => AttendanceBloc(sl(), sl()));
  // Use case
  sl.registerLazySingleton<UseCaseCheckInOrOut>(() => UseCaseCheckInOrOut());
  sl.registerLazySingleton<UseCaseCheckSP>(() => UseCaseCheckSP());
  // Repository
  sl.registerLazySingleton<AttendanceRepository>(() => AttendanceRepositoryImpl(dataSource: sl()));
  //! Future ReceiveGift
  //Bloc
  sl.registerFactory<ReceiveGiftBloc>(() => ReceiveGiftBloc());

  // Repository
  sl.registerLazySingleton<ReceiveGiftRepository>(() => ReceiveGiftRepositoryImpl(storage: sl()));
}

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/core/util/validate_form.dart';
import 'package:sp_2021/feature/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:sp_2021/feature/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_sp.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_inout.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:sp_2021/feature/check_voucher/data/datasources/check_voucher_remote_datasource.dart';
import 'package:sp_2021/feature/check_voucher/data/repositories/check_voucher_repository_impl.dart';
import 'package:sp_2021/feature/check_voucher/domain/repositories/check_voucher_repository.dart';
import 'package:sp_2021/feature/check_voucher/domain/usecases/check_voucher_usecase.dart';
import 'package:sp_2021/feature/check_voucher/presentation/blocs/check_voucher_bloc.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:sp_2021/feature/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/data_today_usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/refresh_data_usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/update_set_gift_usecase.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/highlight/data/datasources/highlight_local_datasource.dart';
import 'package:sp_2021/feature/highlight/data/repositories/highlight_repository_impl.dart';
import 'package:sp_2021/feature/highlight/domain/usecases/highlight_usecase.dart';
import 'package:sp_2021/feature/highlight/domain/usecases/highlight_validate.dart';
import 'package:sp_2021/feature/highlight/presentation/blocs/highlight_bloc.dart';
import 'package:sp_2021/feature/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:sp_2021/feature/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:sp_2021/feature/inventory/domain/repositories/inventory_repository.dart';
import 'package:sp_2021/feature/inventory/domain/usecases/inventory_usecase.dart';
import 'package:sp_2021/feature/inventory/presentation/blocs/inventory_bloc.dart';
import 'package:sp_2021/feature/login/domain/repositories/login_repository.dart';
import 'package:sp_2021/feature/login/domain/usecases/usecase_login.dart';
import 'package:sp_2021/feature/login/domain/usecases/usecase_logout.dart';
import 'package:sp_2021/feature/notification/data/datasources/notification_local_data_source.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_local_datasource.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_remote_datasource.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_gift_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_receive_gift_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_strongbow_wheel_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/use_voucher_usecase.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/rival_sale_price/data/datasources/rival_sale_price_local_data_source.dart';
import 'package:sp_2021/feature/sale_price/data/datasources/sale_price_local_data_source.dart';
import 'package:sp_2021/feature/sale_price/data/repositories/sale_price_repository_impl.dart';
import 'package:sp_2021/feature/sale_price/domain/repositories/sale_price_repository.dart';
import 'package:sp_2021/feature/sale_price/domain/usecases/sale_price_usecase.dart';
import 'package:sp_2021/feature/sale_price/presentation/blocs/sale_price_bloc.dart';
import 'package:sp_2021/feature/send_requirement/data/datasources/send_requirement_local_data_source.dart';
import 'package:sp_2021/feature/send_requirement/data/datasources/send_requirement_remote_data_source.dart';
import 'package:sp_2021/feature/send_requirement/data/repositories/send_requirement_repository_impl.dart';
import 'package:sp_2021/feature/send_requirement/domain/repositories/send_requirement_repository.dart';
import 'package:sp_2021/feature/send_requirement/domain/usecases/send_requirement_usecase.dart';
import 'package:sp_2021/feature/send_requirement/presentation/blocs/send_requirement_bloc.dart';
import 'package:sp_2021/feature/setting/data/datasources/setting_remote_data_source.dart';
import 'package:sp_2021/feature/setting/data/repositories/setting_repository_impl.dart';
import 'package:sp_2021/feature/setting/domain/repositories/setting_repository.dart';
import 'package:sp_2021/feature/setting/domain/usecases/setting_usecase.dart';
import 'package:sp_2021/feature/setting/presentation/blocs/setting_bloc.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';
import 'package:sp_2021/feature/sync_data/domain/repositories/sync_repository.dart';
import 'package:sp_2021/feature/sync_data/domain/usecases/sync_usecase.dart';
import 'package:sp_2021/feature/sync_data/presentation/blocs/sync_data_bloc.dart';
import 'core/api/myDio.dart';
import 'core/platform/network_info.dart';
import 'feature/attendance/presentation/blocs/map_bloc.dart';
import 'feature/dashboard/domain/usecases/save_to_local_usecase.dart';
import 'feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'feature/highlight/data/datasources/highlight_remote_datasource.dart';
import 'feature/highlight/domain/repositories/highlight_repository.dart';
import 'feature/inventory/data/repositories/inventory_repository_impl.dart';
import 'feature/login/data/datasources/login_remote_datasource.dart';
import 'feature/login/data/repositories/login_repository_impl.dart';
import 'feature/login/presentation/blocs/authentication_bloc.dart';
import 'feature/login/presentation/blocs/login_bloc.dart';
import 'feature/receive_gift/data/repositories/receive_gift_repository_impl.dart';
import 'feature/receive_gift/domain/usecases/handle_wheel_usecase.dart';
import 'feature/receive_gift/domain/usecases/validate_form_usecase.dart';
import 'feature/rival_sale_price/data/datasources/rival_sale_price_remote_data_source.dart';
import 'feature/rival_sale_price/data/repositories/rival_sale_price_repository_impl.dart';
import 'feature/rival_sale_price/domain/repositories/rival_sale_price_repository.dart';
import 'feature/rival_sale_price/domain/usecases/rival_sale_price_usecase.dart';
import 'feature/rival_sale_price/presentation/blocs/rival_sale_price_bloc.dart';
import 'feature/sale_price/data/datasources/sale_price_remote_data_source.dart';
import 'feature/sync_data/data/repositories/sync_repository_impl.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dialogs>(() => Dialogs());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ValidateForm>(() => ValidateForm());
  //! External
  sl.registerLazySingleton<CDio>(() => CDio());
  sl.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());

  //! Features - Login //
  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(remoteDataSource: sl(),networkInfo: sl(), dashBoardLocal: sl(),));
  //Use case
  sl.registerLazySingleton<UsecaseLogin>(() => UsecaseLogin(repository: sl()));
  sl.registerLazySingleton<UseCaseLogout>(
      () => UseCaseLogout(repository: sl()));
  // Bloc
  sl.registerLazySingleton<AuthenticationBloc>(
      () => AuthenticationBloc(sharedPreferences: sl()));
  sl.registerFactory<LoginBloc>(
      () => LoginBloc(login: sl(), logout: sl(), authenticationBloc: sl(), dashboardBloc: sl()));


  //! Features - Dashboard
  // DataSource
  sl.registerLazySingleton<DashBoardRemoteDataSource>(
      () => DashBoardRemoteDataSourceImpl(cDio: sl()));
  sl.registerLazySingleton<DashBoardLocalDataSource>(
      () => DashBoardLocalDataSourceImpl(sharedPrefer: sl()));
  // Repository
  sl.registerLazySingleton<DashboardRepository>(() =>
      DashboardRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()));
  // UseCase
  sl.registerLazySingleton<SaveDataToLocalUseCase>(
      () => SaveDataToLocalUseCase(repository: sl(), networkInfo: sl()));
  sl.registerLazySingleton<UpdateDataUseCase>(() => UpdateDataUseCase(repository: sl(), networkInfo: sl()));
  sl.registerLazySingleton<DataTodayUseCase>(() => DataTodayUseCase(repository: sl(), networkInfo: sl()));
  sl.registerLazySingleton<RefreshDataUseCase>(() => RefreshDataUseCase(repository: sl(), networkInfo: sl()));
  // Bloc
  sl.registerLazySingleton<DashboardBloc>(() => DashboardBloc(
      saveDataToLocal: sl(), dataToday: sl(),refreshData: sl(), local: sl(), authenticationBloc: sl()));
  sl.registerLazySingleton<TabBloc>(() => TabBloc());


  //! Feature Attendance
  // Data Source
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
      () => AttendanceRepositoryImpl(remote: sl(),dashBoardLocal: sl(), syncRepository: sl()));
  // Use case
  sl.registerLazySingleton<UseCaseCheckInOrOut>(
      () => UseCaseCheckInOrOut(repository: sl()));
  sl.registerLazySingleton<UseCaseCheckSP>(
      () => UseCaseCheckSP(repository: sl()));
  //Bloc
  sl.registerFactory<MapBloc>(() => MapBloc());
  sl.registerFactory<AttendanceBloc>(() => AttendanceBloc(useCaseCheckInOrOut: sl(), authenticationBloc: sl(), dashboardBloc: sl()));
  sl.registerFactory<CheckAttendanceBloc>(() => CheckAttendanceBloc(dashboardBloc: sl(), authenticationBloc: sl(), useCaseCheckSP: sl()));

  //! Feature Sync Data
  // Data Source
  sl.registerLazySingleton<SyncLocalDataSource>(() => SyncLocalDataSourceImpl());
  // Repository
  sl.registerLazySingleton<SyncRepository>(() => SyncRepositoryImpl(local: sl(),dashBoardLocalDataSource: sl(), highLightLocalDataSource: sl(),inventoryLocalDataSource: sl(), rivalSalePriceLocalDataSource: sl(),salePriceLocalDataSource: sl(),receiveGiftLocalDataSource: sl(), networkInfo: sl(), salePriceRepository: sl(),inventoryRepository: sl(), rivalSalePriceRepository: sl(), sendRequirementRepository: sl(), highlightRepository: sl(),receiveGiftRepository: sl()));
  // UseCase
  sl.registerLazySingleton<SyncUseCase>(() => SyncUseCase(repository: sl()));
  // Bloc
  sl.registerFactory<SyncDataBloc>(() => SyncDataBloc(authenticationBloc: sl(), synchronous: sl(), dashboardBloc: sl<DashboardBloc>()));


  //! Future Receive Gift
  sl.registerLazySingleton<ValidateFormUseCase>(() => ValidateFormUseCase(validateForm: sl()));
  // Data Source
  sl.registerLazySingleton<ReceiveGiftLocalDataSource>(() => ReceiveGiftLocalDataSourceImpl(local: sl(), syncLocal: sl()));
  sl.registerLazySingleton<ReceiveGiftRemoteDataSource>(() => ReceiveGiftRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<ReceiveGiftRepository>(
      () => ReceiveGiftRepositoryImpl(local: sl(),networkInfo: sl(),remote: sl(),dashboardLocal: sl(), updateSetGift: sl()));
  // UseCase
  sl.registerLazySingleton<UseVoucherUseCase>(() => UseVoucherUseCase(repository: sl()));
  sl.registerLazySingleton<HandleGiftUseCase>(
      () => HandleGiftUseCase(repository: sl()));
  sl.registerLazySingleton<HandleWheelUseCase>(
      () => HandleWheelUseCase(repository: sl()));
  sl.registerLazySingleton<HandleStrongBowWheelUseCase>(() => HandleStrongBowWheelUseCase(repository: sl()));
  sl.registerLazySingleton<HandleReceiveGiftUseCase>(
          () => HandleReceiveGiftUseCase(repository: sl()));
  //Bloc
  sl.registerFactory<ReceiveGiftBloc>(
      () => ReceiveGiftBloc(local: sl(), handleGift: sl(), useVoucher: sl(), sharedPrefer: sl(), handleWheel: sl(), authenticationBloc: sl(), dashboardBloc: sl(),handleStrongBowWheel: sl(), localData: sl(), handleReceiveGift: sl(), validateForm: sl()));


  //! Feature Check Voucher
  // Data Source
  sl.registerLazySingleton<CheckVoucherRemoteDataSource>(
      () => CheckVoucherRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<CheckVoucherRepository>(
      () => CheckVoucherRepositoryImpl(remote: sl()));
  // UseCase
  sl.registerLazySingleton<CheckVoucherUseCase>(
      () => CheckVoucherUseCase(repository: sl()));
  // Bloc
  sl.registerFactory<CheckVoucherBloc>(
      () => CheckVoucherBloc(checkVoucher: sl(),dashboardBloc: sl(), authenticationBloc: sl()));


  //! Feature Inventory//
  // Data Source
  sl.registerLazySingleton<InventoryLocalDataSource>(() => InventoryLocalDataSourceImpl(syncLocal: sl()));
  sl.registerLazySingleton<InventoryRemoteDataSource>(
      () => InventoryRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<InventoryRepository>(
      () => InventoryRepositoryImpl(local: sl(), remote: sl(),syncLocal: sl(),networkInfo: sl(),dashboardLocal: sl()));
  // UseCase
  sl.registerLazySingleton<UpdateInventory>(
      () => UpdateInventory(repository: sl()));
  // Bloc
  sl.registerFactory<InventoryBloc>(
      () => InventoryBloc(updateInventory: sl(), authenticationBloc: sl(), dashboardBloc: sl(), localData: sl()));


  //! Feature SalePrice
  // Data Source
  sl.registerLazySingleton<SalePriceLocalDataSource>(() => SalePriceLocalDataSourceImpl(syncLocalDataSource: sl()));
  sl.registerLazySingleton<SalePriceRemoteDataSource>(
      () => SalePriceRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<SalePriceRepository>(
      () => SalePriceRepositoryImpl(remote: sl(), local: sl(), dashBoardLocal: sl(), sync: sl(),networkInfo: sl()));
  // UseCase
  sl.registerLazySingleton<SalePriceUseCase>(
      () => SalePriceUseCase(repository: sl()));
  // Bloc
  sl.registerFactory<SalePriceBloc>(
      () => SalePriceBloc(dashboardBloc: sl(), authenticationBloc: sl(), updateSalePrice: sl(), dashBoardLocal: sl()));


  //! Feature RivalSalePrice
  // Data Source
  sl.registerLazySingleton<RivalSalePriceLocalDataSource>(() => RivalSalePriceLocalDataSourceImpl(syncLocalDataSource: sl()));
  sl.registerLazySingleton<RivalSalePriceRemoteDataSource>(
          () => RivalSalePriceRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<RivalSalePriceRepository>(
          () => RivalSalePriceRepositoryImpl(remote: sl(), local: sl(), dashBoardLocal: sl(), sync: sl(),networkInfo: sl()));
  // UseCase
  sl.registerLazySingleton<RivalSalePriceUseCase>(
          () => RivalSalePriceUseCase(repository: sl()));
  // Bloc
  sl.registerFactory<RivalSalePriceBloc>(() => RivalSalePriceBloc(authenticationBloc: sl(), localData: sl(), dashboardBloc: sl(), updateRivalSalePrice: sl()));


  //! Feature HighLight
  // Data Source
  sl.registerLazySingleton<HighLightLocalDataSource>(() => HighlightLocalDataSourceImpl(syncLocal: sl()));
  sl.registerLazySingleton<HighlightRemoteDataSource>(() => HighlightRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<HighlightRepository>(() => HighlightRepositoryImpl(local: sl(), remote: sl(), dashboardLocal: sl(), networkInfo: sl()));
  // UseCase
  sl.registerLazySingleton<HighLightUseCase>(() => HighLightUseCase(repository: sl()));
  sl.registerLazySingleton<HighlightValidateUseCase>(() => HighlightValidateUseCase());
  // Bloc
  sl.registerFactory<HighlightBloc>(() => HighlightBloc(highlightValidate: sl(), localData: sl(), authenticationBloc: sl(), dashboardBloc: sl(), uploadHighlight: sl()));


  //! Feature Send Requirement
  // Data Source
  sl.registerLazySingleton<SendRequirementLocalDataSource>(() => SendRequirementLocalDataSourceImpl(syncLocal: sl()));
  sl.registerLazySingleton<SendRequirementRemoteDataSource>(() => SendRequirementRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<SendRequirementRepository>(() => SendRequirementRepositoryImpl(networkInfo: sl(), local: sl(), remote: sl()));
  // UseCase
  sl.registerLazySingleton<SendRequirementUseCase>(() => SendRequirementUseCase(repository: sl()));
  // Bloc
  sl.registerFactory<SendRequirementBloc>(() => SendRequirementBloc(sendRequirement: sl()));
  
  //! Feature Notification
  // Data Source
  sl.registerLazySingleton<NotificationLocalDataSource>(() => NotificationLocalDataSourceImpl());

  //! Feature Setting
  // Data Source
  sl.registerLazySingleton<SettingRemoteDataSource
  >(() => SettingRemoteDataSourceImpl(cDio: sl()));
  // Repository
  sl.registerLazySingleton<SettingRepository>(() => SettingRepositoryImpl(remote: sl()));
  // UseCase
  sl.registerLazySingleton<SettingUseCase>(() => SettingUseCase(repository: sl()));
  // Bloc
  sl.registerFactory<SettingBloc>(() => SettingBloc(checkVersion: sl()));
}

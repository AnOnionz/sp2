import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/data_today_usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/refresh_data_usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/save_to_local_usecase.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';



part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SaveDataToLocalUseCase saveDataToLocal;
  final DataTodayUseCase dataToday;
  final RefreshDataUseCase refreshData;
  final DashBoardLocalDataSource local;
  final AuthenticationBloc authenticationBloc;

  DashboardBloc({this.saveDataToLocal, this.dataToday, this.refreshData, this.local, this.authenticationBloc})
      : super(DashboardInitial());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is SaveServerDataToLocalData) {
      yield DashboardSaving();
      final result = local.loadInitDataToLocal ? await saveDataToLocal(NoParams()) : await dataToday(NoParams());
      yield result.fold((failure) {
        if (failure is UnAuthenticateFailure) {
          authenticationBloc.add(ShutDown(willPop: 2));
          return null;
        }
        if (failure is InternetFailure) {
          return DashboardNoInternetInitData();
        }
        if (failure is InternalFailure) {
          return DashboardFailure(message: failure.message, willPop: 1);
        }
        return DashboardFailure(message: failure.message, willPop: 1);
      }, (r) => DashboardSaved());
    }
    if(event is RefreshApp){
      yield DashboardSaving();
      final result = await refreshData(NoParams());
      yield result.fold((failure) {
        if (failure is UnAuthenticateFailure) {
          authenticationBloc.add(ShutDown(willPop: 2));
          return null;
        }
        if (failure is InternetFailure) {
          return DashboardNoInternetInitData();
        }
        if (failure is InternalFailure) {
          return DashboardFailure(message: failure.message, willPop: 1);
        }
        return DashboardFailure(message: failure.message, willPop: 1);
      }, (r) => DashboardRefresh());
    }
    if (event is SyncRequired) {
      yield DashboardHasSync(message: event.message);
    }
    if (event is AccessInternet) {
      yield DashboardNoInternet();
    }
    if (event is RequiredCheckInOrCheckOut) {
      yield DashboardRequiredCheckInOrOut(
          message: event.message, willPop: event.willPop ?? 0);
    }
    if(event is InternalServer){
      yield DashboardFailure(message: "Máy chủ đang gặp sự cố, vui lòng thử lại sau", willPop: event.willPop ?? 1);
    }
    if(event is RequireUpdateNewVersion){
      yield DashboardRequiredUpdate();
    }
    if(event is ThrowFailure){
     yield DashboardFailure(message: event.message, willPop: 0);
    }

  }


}

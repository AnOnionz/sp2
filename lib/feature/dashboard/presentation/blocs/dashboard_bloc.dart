import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/today_data_entity.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/usecase_save_to_local.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UseCaseSaveDataToLocal saveDataToLocal;
  final DashBoardLocalDataSource local;
  final AuthenticationBloc authenticationBloc;

  DashboardBloc({this.saveDataToLocal, this.local, this.authenticationBloc})
      : super(DashboardInitial());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is SaveServerDataToLocalData) {
      await MyDateTime.getToday();
      await Hive.openBox<DataTodayEntity>(AuthenticationBloc.outlet.code + DATA_DAY);
      await Hive.openBox<CustomerEntity>(MyDateTime.today + CUSTOMER_BOX);
      if (local.loadInitDataToLocal) {
        yield DashboardSaving();
        final result = await saveDataToLocal(NoParams());
        yield result.fold((failure) {
          if (failure is UnAuthenticateFailure) {
            authenticationBloc.add(ShutDown(willPop: 1));
            return null;
          }
          if (failure is InternetFailure) {
            return DashboardNoInternet();
          }
          if (failure is InternalFailure) {
            return DashboardFailure(message: failure.message);
          }
          return DashboardFailure(message: failure.message);
        }, (r) => DashboardSaved());
      }
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
      yield DashboardFailure(message: "Máy chủ đang gặp sự cố, vui lòng thử lại sau");
    }
  }
}

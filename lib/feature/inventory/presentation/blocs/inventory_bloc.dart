import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/inventory/domain/usecases/inventory_usecase.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final DashBoardLocalDataSource localData;
  final UpdateInventory updateInventory;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;

  InventoryBloc({this.authenticationBloc, this.updateInventory, this.dashboardBloc, this.localData}) : super(InventoryInitial());

  @override
  Stream<InventoryState> mapEventToState(
    InventoryEvent event,
  ) async* {
    if(event is InventoryStart){
      final dataToday = localData.dataToday;
      if (dataToday.checkIn != true) {
        dashboardBloc.add(RequiredCheckInOrCheckOut(
            message: 'Phải chấm công trước khi nhập tồn kho', willPop: 2));
      }
    }
   if(event is InventoryUpdate){
     yield InventoryLoading();
     final update = await updateInventory(InventoryParams(inventory: event.inventory));
     yield* _eitherInventoryToState(update, authenticationBloc, dashboardBloc);
   }
  }
  @override
  void onTransition(Transition<InventoryEvent, InventoryState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
Stream<InventoryState> _eitherInventoryToState(
    Either<Failure, bool> either, AuthenticationBloc authenticationBloc, DashboardBloc dashboardBloc ) async* {
    yield either.fold((fail) {
      if (fail is CheckInNullFailure) {
        dashboardBloc.add(RequiredCheckInOrCheckOut(message: fail.message, willPop: 2));
        return InventoryCloseDialog();
      }
      if (fail is UnAuthenticateFailure) {
        authenticationBloc.add(ShutDown(willPop: 2));
        return InventoryCloseDialog();
      }
      if (fail is InternalFailure) {
        dashboardBloc.add(InternalServer());
        return InventoryCloseDialog();
      }
      if (fail is FailureAndCachedToLocal) {
        return InventoryCached();
      }

     return InventoryFailure(message: fail.message);
    }, (r) => InventoryUpdated(message: r ? "Tồn kho cập nhật thành công": '''Tồn kho cập nhật thành công
                                                                                         (chưa bao gồm tồn cuối)'''));

    }

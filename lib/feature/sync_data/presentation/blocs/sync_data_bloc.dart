import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/sync_data/domain/usecases/sync_usecase.dart';

part 'sync_data_event.dart';
part 'sync_data_state.dart';

class SyncDataBloc extends Bloc<SyncDataEvent, SyncDataState> {
  final SyncUseCase synchronous;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  SyncDataBloc({this.synchronous, this.authenticationBloc, this.dashboardBloc,}) : super(SyncDataInitial());

  @override
  Stream<SyncDataState> mapEventToState(
    SyncDataEvent event,
  ) async* {
    if(event is SyncStart){
      yield SyncDataLoading();
      final sync = await synchronous(NoParams());
      yield* _eitherSyncToState(sync, authenticationBloc, dashboardBloc);
    }
  }
}
Stream<SyncDataState> _eitherSyncToState(Either<Failure, bool> either, AuthenticationBloc authenticationBloc, DashboardBloc dashboardBloc,) async*{
  yield either.fold((fail) {
    if (fail is UnAuthenticateFailure) {
      authenticationBloc.add(ShutDown(willPop: 1));
      return SyncDataCloseDialog();
    }
    if (fail is InternalFailure) {
      dashboardBloc.add(InternalServer());
      return SyncDataCloseDialog();
    }
    if(fail is InternetFailure){
      print("abc");
      dashboardBloc.add(AccessInternet());
      return SyncDataCloseDialog();
    }
      return SyncDataFailure(message: fail.message);
  }, (success) => SyncDataSuccess());
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/usecase_save_to_local.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UseCaseSaveDataToLocal saveDataToLocal;
  final DashBoardLocalDataSource local;
  DashboardBloc({this.saveDataToLocal, this.local}) : super(DashboardInitial()){
    add(SaveServerDataToLocalData());
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
      if(event is SaveServerDataToLocalData){
        bool isNoUpdate = local.checkLocalHasData();
        if(!isNoUpdate){
          yield DashboardSaving();
          final result = await saveDataToLocal(NoParams());
          yield result.fold((l) => DashboardSaveFailure(), (r) => DashboardSaved());
        }
      }
  }
  @override
  void onTransition(Transition<DashboardEvent, DashboardState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
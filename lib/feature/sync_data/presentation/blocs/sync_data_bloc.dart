import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sync_data_event.dart';
part 'sync_data_state.dart';

class SyncDataBloc extends Bloc<SyncDataEvent, SyncDataState> {
  SyncDataBloc() : super(SyncDataInitial());

  @override
  Stream<SyncDataState> mapEventToState(
    SyncDataEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

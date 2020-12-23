import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryInitial());

  @override
  Stream<InventoryState> mapEventToState(
    InventoryEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

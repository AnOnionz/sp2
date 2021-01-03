import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/inventory/domain/usecases/inventory_usecase.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final UpdateInventory updateInventory;
  final AuthenticationBloc authenticationBloc;
  InventoryBloc({this.authenticationBloc, this.updateInventory}) : super(InventoryInitial());

  @override
  Stream<InventoryState> mapEventToState(
    InventoryEvent event,
  ) async* {
   if(event is InventoryUpdate){
     final update = await updateInventory(InventoryParams(products: event.products));
     yield* _eitherInventoryToState(update, authenticationBloc);
   }
  }
  @override
  void onTransition(Transition<InventoryEvent, InventoryState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
Stream<InventoryState> _eitherInventoryToState(
    Either<Failure, bool> either, AuthenticationBloc bloc) async* {
    yield either.fold((fail) { if (fail is UnAuthenticateFailure){
      bloc.add(ShutDown(willPop: 1));
      return null ;
     }
     return InventoryUpdateFailure();
    }, (r) => InventoryUpdated());

    }

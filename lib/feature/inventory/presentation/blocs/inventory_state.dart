part of 'inventory_bloc.dart';

abstract class InventoryState {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
}
class InventoryLoading extends InventoryState{}
class InventoryUpdated extends InventoryState{}
class InventoryCached extends InventoryState{}
class InventoryFailure extends InventoryState{
  final String message;

  InventoryFailure({this.message});

}
class InventoryCloseDialog extends InventoryState {}



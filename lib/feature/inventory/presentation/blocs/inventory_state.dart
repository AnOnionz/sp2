part of 'inventory_bloc.dart';

abstract class InventoryState {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
}
class InventoryUpdated extends InventoryState{}
class InventoryUpdateFailure extends InventoryState{}



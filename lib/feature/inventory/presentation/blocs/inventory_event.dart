part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
}
class InventoryStart extends InventoryEvent {
  @override
  List<Object> get props => [];
}
class InventoryUpdate extends InventoryEvent{
  final InventoryEntity inventory;

  InventoryUpdate({this.inventory});
  @override
  List<Object> get props => [inventory];
}

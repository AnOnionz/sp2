part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
  @override
  List<Object> get props => [];
}

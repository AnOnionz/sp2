part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
}
class InventoryUpdate extends InventoryEvent{
  final List<ProductEntity> products;

  InventoryUpdate({this.products});
  @override
  List<Object> get props => [products];
}

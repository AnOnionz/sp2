part of 'sale_price_bloc.dart';

@immutable
abstract class SalePriceEvent {}

class SalePriceLoadData extends SalePriceEvent {}
class SalePriceSave extends SalePriceEvent{
  final List<ProductEntity> products;

  SalePriceSave({this.products});
}

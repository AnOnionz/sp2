part of 'sale_price_bloc.dart';

@immutable
abstract class SalePriceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SalePriceUpdate extends SalePriceEvent{
  final List<ProductEntity> products;

  SalePriceUpdate({this.products});

  @override
  List<Object> get props => [products];
}

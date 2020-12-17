part of 'sale_price_bloc.dart';

@immutable
abstract class SalePriceState {

}

class SalePriceInitial extends SalePriceState {}
class SalePriceSaving extends SalePriceState {}
class SalePriceSaved extends SalePriceState {}

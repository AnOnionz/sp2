part of 'sale_price_bloc.dart';

@immutable
abstract class SalePriceState {
  const SalePriceState();
}
class SalePriceCloseDialog extends SalePriceState {}
class SalePriceInitial extends SalePriceState {}
class SalePriceLoading extends SalePriceState {}
class SalePriceUpdated extends SalePriceState {}
class SalePriceCached extends SalePriceState {}
class SalePriceUpdateFailure extends SalePriceState {
  final String message;

  SalePriceUpdateFailure({this.message});
}

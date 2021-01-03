part of 'rival_sale_price_bloc.dart';

@immutable
abstract class RivalSalePriceState {
  const RivalSalePriceState();
}

class RivalSalePriceInitial extends RivalSalePriceState {}
class RivalSalePriceLoading extends RivalSalePriceState {}
class RivalSalePriceUpdated extends RivalSalePriceState {}
class RivalSalePriceCached extends RivalSalePriceState {}
class RivalSalePriceFailure extends RivalSalePriceState {
  final String message;

  RivalSalePriceFailure({this.message});
}
class RivalSalePriceCloseDialog extends RivalSalePriceState {}
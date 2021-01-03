part of 'rival_sale_price_bloc.dart';

@immutable
abstract class RivalSalePriceEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class RivalSalePriceUpdate extends RivalSalePriceEvent{
  final List<RivalProductEntity> rivals;

  RivalSalePriceUpdate({this.rivals});

  @override
  List<Object> get props => [rivals];
}

import 'package:equatable/equatable.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';

class HandleWheelEntity extends Equatable{
  final List<GiftEntity> lucky;
  final SetGiftEntity setCurrent;

  HandleWheelEntity({this.lucky, this.setCurrent});
  @override
  List<Object> get props => [lucky, setCurrent];

}
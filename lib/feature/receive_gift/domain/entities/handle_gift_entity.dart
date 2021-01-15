import 'package:equatable/equatable.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';

class HandleGiftEntity extends Equatable{
  final List<Gift> gifts;
  final SetGiftEntity setCurrent;
  final SetGiftEntity setSBCurrent;

  HandleGiftEntity({this.gifts, this.setCurrent, this.setSBCurrent});


  @override
  List<Object> get props => [gifts, setCurrent, setSBCurrent];

}
class HandleStrongBowGiftEntity extends HandleGiftEntity{

  HandleStrongBowGiftEntity({List<Gift> gifts, SetGiftEntity setSBCurrent}) : super (gifts: gifts, setSBCurrent: setSBCurrent) ;



}
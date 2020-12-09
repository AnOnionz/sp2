import 'package:equatable/equatable.dart';
import 'package:sp_2021/app/entities/gift_entity.dart';
import 'package:sp_2021/app/entities/product_entity.dart';

class GiftCanReceive extends Equatable{
  final List<Gift> giftReceives;

  GiftCanReceive({this.giftReceives});

  @override
  List<Object> get props => [giftReceives];

  @override
  String toString() {
    return 'GiftCanReceive{giftReceives: $giftReceives}';
  }
}
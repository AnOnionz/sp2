import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
@immutable
// ignore: must_be_immutable
class Gift extends Equatable{
  final int id;

  Gift({this.id});

  @override
  List<Object> get props => [id];
}
class Wheel extends Gift{

  Wheel({int id}): super(id: id);


  @override
  String toString() {
    return 'Wheel{}';
  }

  @override
  List<Object> get props => [];

}
@immutable
// ignore: must_be_immutable
 abstract class GiftEntity extends Gift{
  final int brandId;
  final int giftId;
  final String code;
  final String name;
  final String image;
  final int amountDefault;
  int amountCurrent;
  int amountReceive;

  GiftEntity copyWith({int current, int receive});

  GiftEntity({this.giftId, this.code, this.brandId, this.name, this.image, this.amountDefault, this.amountCurrent, this.amountReceive}) : super(id: giftId);

  @override
  String toString() {
    return 'GiftEntity{brandId: $brandId, giftId: $giftId, code: $code, name: $name, image: $image, amountDefault: $amountDefault, amountCurrent: $amountCurrent, amountReceive: $amountReceive}';
  }

  @override
  List<Object> get props => [brandId, giftId, name, code, amountCurrent, amountReceive, amountDefault, image];
}
class Nen extends GiftEntity{
  Nen({int brandId, int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(brandId: brandId, giftId: giftId, code: code, name: name, image: image, amountDefault: amountDefault, amountReceive: amountReceive, amountCurrent: amountCurrent);
  Nen.internal() : super (giftId: 2);

  @override
  String toString() {
    return 'Nen{$amountCurrent}';
  }

  @override
  GiftEntity copyWith({int current, int receive}) {
    return Nen(brandId: this.brandId, giftId: this.giftId, code: this.code, name: this.name, image: this.image, amountDefault: this.amountDefault, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
class StrongBowGift extends GiftEntity{
  StrongBowGift({int brandId, int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(brandId: brandId, giftId: giftId, code: code, name: name, image: image, amountDefault: amountDefault, amountReceive: amountReceive, amountCurrent: amountCurrent);
  StrongBowGift.internal() : super (giftId: 3);

  @override
  String toString() {
    return 'StrongBowGift{$amountCurrent}';
  }

  @override
  GiftEntity copyWith({int current, int receive}) {
    return StrongBowGift(brandId: this.brandId, giftId: this.giftId, code: this.code, name: this.name, image: this.image, amountDefault: this.amountDefault, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
class Voucher extends GiftEntity{
  Voucher({int brandId, int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(brandId: brandId, giftId: giftId, code: code, name: name, image: image, amountDefault: amountDefault, amountReceive: amountReceive, amountCurrent: amountCurrent);
  Voucher.internal() : super (giftId: 1);

  @override
  String toString() {
    return 'Voucher{$amountCurrent}';
  }

  @override
  GiftEntity copyWith({int current, int receive}) {
    return Voucher(brandId: this.brandId, giftId: this.giftId, code: this.code, name: this.name, image: this.image, amountDefault: this.amountDefault, amountCurrent: current ?? this.amountCurrent
        , amountReceive: receive ?? this.amountReceive);
  }
}
class Pack6 extends GiftEntity{
  Pack6({int brandId, int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(brandId: brandId, giftId: giftId, code: code, name: name, image: image, amountDefault: amountDefault, amountReceive: amountReceive, amountCurrent: amountCurrent);
  Pack6.internal() : super (giftId: 4);

  @override
  String toString() {
    return 'Pack6{$amountCurrent}';
  }

  @override
  GiftEntity copyWith({int current, int receive}) {
    return Pack6(brandId: this.brandId, giftId: this.giftId, code: this.code, name: this.name, image: this.image, amountDefault: this.amountDefault, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
class Pack4 extends GiftEntity{
  Pack4({int brandId, int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(brandId: brandId, giftId: giftId, code: code, name: name, image: image, amountDefault: amountDefault, amountReceive: amountReceive, amountCurrent: amountCurrent);
  Pack4.internal() : super (giftId: 5);

  @override
  String toString() {
    return 'Pack4{$amountCurrent}';
  }

  @override
  GiftEntity copyWith({int current, int receive}) {
    return Pack4(brandId: this.brandId, giftId: this.giftId, code: this.code, name: this.name, image: this.image, amountDefault: this.amountDefault, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}


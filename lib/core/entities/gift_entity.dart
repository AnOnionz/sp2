import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'gift_entity.g.dart';

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
@HiveType(typeId: 7)
// ignore: must_be_immutable
class GiftEntity extends Gift with HiveObject{
  @HiveField(0)
  final int giftId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;
  @HiveField(3)
  int amountCurrent;
  int amountReceive;

  String get asset =>  "assets/images/$name.png";

  GiftEntity upReceive () {
    this.amountReceive += 1 ;
    return this;
  }
  GiftEntity downCurrent () {
    this.amountCurrent -= 1 ;
    return this;
  }

  GiftEntity({this.giftId, this.name, this.image, this.amountCurrent, this.amountReceive}) : super(id: giftId);

  @override
  String toString() {
    return 'GiftEntity{brandId:  giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive}';
  }

  @override
  List<Object> get props => [giftId];
}

// ignore: must_be_immutable
class Nen extends GiftEntity{
  Nen({ int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(giftId: giftId, name: name, image: image,  amountReceive: 1, amountCurrent: amountCurrent);
  Nen.internal() : super (giftId: 1, name: "Nến", amountReceive: 1);

  @override
  String toString() {
    return 'Nen{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return Nen( giftId: this.giftId, name: this.name, image: this.image, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
// ignore: must_be_immutable
class StrongBowGift extends GiftEntity{
  StrongBowGift({ int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super( giftId: giftId, name: name, image: image, amountReceive: 1, amountCurrent: amountCurrent);
  StrongBowGift.internal() : super (giftId: 3, name: "Strongbow", amountReceive: 1);

  @override
  String toString() {
    return 'StrongBowGift{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return StrongBowGift(giftId: this.giftId, name: this.name, image: this.image, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
// ignore: must_be_immutable
class Voucher extends GiftEntity{
  Voucher({int giftId, String code, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super( giftId: giftId, name: name, image: image, amountReceive: 1, amountCurrent: amountCurrent);
  Voucher.internal() : super (giftId: 2, name: "Voucher", amountReceive: 1);

  @override
  String toString() {
    return 'Voucher{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return Voucher( giftId: this.giftId, name: this.name, image: this.image,  amountCurrent: current ?? this.amountCurrent
        , amountReceive: receive ?? this.amountReceive);
  }
}
// ignore: must_be_immutable
class Pack6 extends GiftEntity{
  Pack6({int giftId, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(giftId: giftId, name: name, image: image, amountReceive: 1, amountCurrent: amountCurrent);
  Pack6.internal() : super (giftId: 5, name: "Pack6", amountReceive: 1);

  @override
  String toString() {
    return 'Pack6{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return Pack6( giftId: this.giftId,  name: this.name, image: this.image, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
// ignore: must_be_immutable
class Pack4 extends GiftEntity{
  Pack4({ int giftId, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(giftId: giftId, name: name, image: image, amountReceive: 1, amountCurrent: amountCurrent);
  Pack4.internal() : super (giftId: 4, name: "Pack4", amountReceive: 1);

  @override
  String toString() {
    return 'Pack4{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return Pack4( giftId: this.giftId, name: this.name, image: this.image, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
// ignore: must_be_immutable
class Alu extends GiftEntity{
  Alu({ int giftId, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(giftId: giftId, name: name, image: image, amountReceive: 1, amountCurrent: amountCurrent);
  Alu.internal() : super (giftId: 7, name: "Alu", amountReceive: 1);

  @override
  String toString() {
    return 'Alu{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return Pack4( giftId: this.giftId, name: this.name, image: this.image, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}
// ignore: must_be_immutable
class Magnum extends GiftEntity{
  Magnum({ int giftId, String name, String image, int amountDefault, int amountCurrent, int amountReceive}) : super(giftId: giftId, name: name, image: image, amountReceive: 1, amountCurrent: amountCurrent);
  Magnum.internal() : super (giftId: 6, name: "Magnum", amountReceive: 1);

  @override
  String toString() {
    return 'Magnum{$amountCurrent}';
  }

  GiftEntity copyWith({int current, int receive}) {
    return Pack4( giftId: this.giftId, name: this.name, image: this.image, amountCurrent: current ?? this.amountCurrent, amountReceive: receive ?? this.amountReceive);
  }
}


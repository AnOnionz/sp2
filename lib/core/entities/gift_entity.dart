import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'gift_entity.g.dart';


@immutable
// ignore: must_be_immutable
class Gift extends Equatable {
  final int id;
  Gift({this.id});

  @override
  List<Object> get props => [id];
}

class Wheel extends Gift {
  Wheel({int id}) : super(id: id);

  @override
  String toString() {
    return 'Wheel{}';
  }

}
class StrongBowWheel extends Gift {
  StrongBowWheel({int id}) : super(id: id);

  @override
  String toString() {
    return 'StrongBowWheel{}';
  }
}

@immutable
@HiveType(typeId: 7)
// ignore: must_be_immutable
class GiftEntity extends Gift with HiveObject {
  @HiveField(0)
  final int giftId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;
  @HiveField(3)
  int amountCurrent;
  int amountReceive;

  String get asset {return name != "Nến" ? "assets/images/$name.png" : "assets/images/Nen.png"; }

//  switch(fields[0] as int){
//  case 1: return Nen(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  case 2: return Voucher(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  case 3: return StrongBowGift(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  case 4: return Pack4(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  case 5: return Pack6(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  case 6: return Alu(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  case 7: return Magnum(
//  giftId: fields[0] as int,
//  name: fields[1] as String,
//  image: fields[2] as String,
//  amountCurrent: fields[3] as int,
//  );
//  }

  GiftEntity upReceive() {
    this.amountReceive += amountReceive;
    return this;
  }

  GiftEntity downCurrent() {
    this.amountCurrent -= amountReceive;
    return this;
  }

  GiftEntity(
      {this.giftId,
      this.name,
      this.image,
      this.amountCurrent,
      this.amountReceive})
      : super(id: giftId);

  factory GiftEntity.fromJson(Map<String, dynamic> json){
    switch (json['id']){
      case 1: return Nen(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
      case 2: return Voucher(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
      case 3: return StrongBowGift(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
      case 4: return Pack4(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
      case 5: return Pack6(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
      case 6: return Alu(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
      case 7: return Magnum(
        giftId: json['id'] as int,
        name: json['name'] as String,
        image: json["img_url"] as String,
      );
    }
    return GiftEntity(
      giftId: json['id'] as int,
      name: json['name'] as String,
      image: json["img_url"] as String,
    );

  }
  Map<String, dynamic> toJson(){
    return {
      'sku_id':giftId,
      'qty': amountReceive
    };
  }


  @override
  String toString() {
    return 'GiftEntity{brandId:  giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive}';
  }

  @override
  List<Object> get props => [giftId];


}

// ignore: must_be_immutable
class Nen extends GiftEntity {
  Nen({int giftId,
      String code,
      String name,
      String image,
      int amountDefault,
      int amountCurrent,
      int amountReceive})
      : super(
            giftId: 1,
            name: 'Nen',
            image: image,
            amountReceive: 1,
            amountCurrent: amountCurrent);
  Nen.clone({int giftId,
    String code,
    String name,
    String image,
    int amountDefault,
    int amountCurrent,
    int amountReceive}):super(
      giftId: giftId,
      name: name,
      image: image,
      amountReceive: 1,
      amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'Nen{receive: $amountReceive, qty: $amountCurrent}';
  }
}
// ignore: must_be_immutable
class Voucher extends GiftEntity {
  Voucher(
      {int giftId,
      String code,
      String name,
      String image,
      int amountDefault,
      int amountCurrent,
      int amountReceive})
      : super(
            giftId: 2,
            name: name,
            image: image,
            amountReceive: 1,
            amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'Voucher{receive: $amountReceive, qty: $amountCurrent}';
  }
}
// ignore: must_be_immutable
class StrongBowGift extends GiftEntity {
  StrongBowGift(
      {int giftId,
        String code,
        String name,
        String image,
        int amountDefault,
        int amountCurrent,
        int amountReceive})
      : super(
      giftId: 3,
      name: name,
      image: image,
      amountReceive: 1,
      amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'StrongBowGift{receive: $amountReceive, qty: $amountCurrent}';
  }
}
class Pack4 extends GiftEntity {
  Pack4(
      {int giftId,
        String name,
        String image,
        int amountDefault,
        int amountCurrent,
        int amountReceive})
      : super(
      giftId: 4,
      name: name,
      image: image,
      amountReceive: 1,
      amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'Pack4{receive: $amountReceive, qty: $amountCurrent}';
  }
}

// ignore: must_be_immutable
class Pack6 extends GiftEntity {
  Pack6(
      {int giftId,
      String name,
      String image,
      int amountDefault,
      int amountCurrent,
      int amountReceive})
      : super(
            giftId: 5,
            name: name,
            image: image,
            amountReceive: 1,
            amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'Pack6{receive: $amountReceive, qty: $amountCurrent}';
  }
}


// ignore: must_be_immutable
class Alu extends GiftEntity {
  Alu(
      {int giftId,
      String name,
      String image,
      int amountDefault,
      int amountCurrent,
      int amountReceive})
      : super(
            giftId: 6,
            name: name,
            image: image,
            amountReceive: 1,
            amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'Alu{receive: $amountReceive, qty: $amountCurrent}';
  }
}

// ignore: must_be_immutable
class Magnum extends GiftEntity {
  Magnum({int giftId,
    String name,
    String image,
    int amountDefault,
    int amountCurrent,
    int amountReceive})
      : super(
      giftId: 7,
      name: name,
      image: image,
      amountReceive: 1,
      amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'Magnum{receive: $amountReceive, qty: $amountCurrent}';
  }
}
  // ignore: must_be_immutable
  class TravelBags extends GiftEntity {
    TravelBags({int giftId,
      String name,
      String image,
      int amountDefault,
      int amountCurrent,
      int amountReceive})
        : super(
        giftId: 8,
        name: name,
        image: image,
        amountReceive: 1,
        amountCurrent: amountCurrent);

    @override
    String toString() {
      return 'TravelBags{$amountReceive}';
    }
  }
  // ignore: must_be_immutable
  class Glass extends GiftEntity {
    Glass(
  {int giftId,
  String name,
  String image,
  int amountDefault,
  int amountCurrent,
  int amountReceive})
      : super(
  giftId: 9,
  name: name,
  image: image,
  amountReceive: 1,
  amountCurrent: amountCurrent);

  @override
  String toString() {
  return 'Glass{$amountReceive}';
  }
}
// ignore: must_be_immutable
class CanvasBag extends GiftEntity {
  CanvasBag(
      {int giftId,
        String name,
        String image,
        int amountDefault,
        int amountCurrent,
        int amountReceive})
      : super(
      giftId: 10,
      name: name,
      image: image,
      amountReceive: 1,
      amountCurrent: amountCurrent);

  @override
  String toString() {
    return 'CanvasBag{$amountReceive}';
  }
}


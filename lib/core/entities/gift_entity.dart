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

  factory Gift.fromJson(Map<String, dynamic> json){
    switch(json['type']){
      case "wheel": return Wheel(id: json['id']);
      case "sbWheel": return StrongBowWheel(id: json['id']);
      case "giftEntity": return GiftEntity.fromJson(json);
    }
    return Gift(
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
    };
  }
}

class Wheel extends Gift {
  Wheel({int id}) : super(id: id);

  @override
  String toString() {
    return 'Wheel{}';
  }

  Map<String, dynamic> toJson(){
    return {
      "type":"wheel",
      'id': id,
    };
  }
}

class StrongBowWheel extends Gift {
  StrongBowWheel({int id}) : super(id: id);

  @override
  String toString() {
    return 'StrongBowWheel{}';
  }
  Map<String, dynamic> toJson(){
    return {
      "type":"sbWheel",
      'id': id,
    };
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
  @HiveField(4)
  int amountReceive;
  String assetGift;
  String get asset => "assets/images/$assetGift.jpg";

  factory GiftEntity.create(GiftEntity giftEntity) {
    switch (giftEntity.giftId) {
      case 1:
        return Nen(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "hn_nen",
        );
      case 2:
        return Voucher(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ??  "hn_magiamgia",
        );
      case 3:
        return StrongBowGift(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "hn_strongbow",
        );
      case 4:
        return Pack4(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ??  "hn_4lon",
        );
      case 5:
        return Pack6(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ??  "hn_pack6",
        );
      case 6:
        return Alu(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "hn_alu",
        );
      case 7:
        return Magnum(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "hn_magnum",
        );
      case 23:
        return Glass(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "st_ly",
        );
      case 24:
        return CanvasBag(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "st_canvas",
        );
      case 25:
        return TravelBags(
          giftId: giftEntity.giftId,
          name: giftEntity.name,
          image: giftEntity.image,
          amountCurrent: giftEntity.amountCurrent ?? 0,
          amountReceive: giftEntity.amountReceive ?? 1,
          assetGift: giftEntity.assetGift ?? "st_dulich",
        );
    }
    return giftEntity;
  }
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
    GiftEntity g = GiftEntity.create(this);
    g.amountReceive +=1;
    return g;
  }

  GiftEntity downCurrent() {
    GiftEntity g = GiftEntity.create(this);
    g.amountCurrent -=1;
    return g;
  }

  GiftEntity(
      {this.giftId,
      this.name,
      this.image,
      this.amountCurrent,
      this.amountReceive,
      this.assetGift})
      : super(id: giftId);

  GiftEntity clone(){
    return GiftEntity(
      giftId: 1,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      image: this.image,
      assetGift: this.assetGift,
    );
  }


  factory GiftEntity.fromJson(Map<String, dynamic> json) {
    switch (json['id']) {
      case 1:
        return Nen(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Nến',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_nen",
        );
      case 2:
        return Voucher(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Mã giảm giá',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_magiamgia",
        );
      case 3:
        return StrongBowGift(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Lon Strongbow',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_strongbow",
        );
      case 4:
        return Pack4(
          giftId: json['id'] as int,
          name: json['name'] as String  ?? '4 lon Tiger',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_4lon",
        );
      case 5:
        return Pack6(
          giftId: json['id'] as int,
          name: json['name'] as String ?? '6 lon Heineken',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_pack6",
        );
      case 6:
        return Alu(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Alu',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_alu",
        );
      case 7:
        return Magnum(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Magnum',
          image: json["img_url"] as String ,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "hn_magnum",
        );
      case 23:
        return Glass(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Ly',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "st_ly",
        );
      case 24:
        return CanvasBag(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Túi canvas',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "st_canvas",
        );
      case 25:
        return TravelBags(
          giftId: json['id'] as int,
          name: json['name'] as String ?? 'Túi du lịch',
          image: json["img_url"] as String,
          amountCurrent: json['qty'] as int ?? 0,
          amountReceive: json['receive'] as int ?? 1,
          assetGift: "st_dulich",
        );
    }
    return GiftEntity(
      giftId: json['id'] as int,
      name: json['name'] as String,
      image: json["img_url"] as String,
      amountCurrent: json['qty'] as int ?? 0,
      amountReceive: json['receive'] as int ?? 1,
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "type":"giftEntity",
      'id': id,
      "name": name,
      "img_url":image,
    };
  }

  Map<String, dynamic> toJsonReceive() {
    return {'sku_id': giftId, 'qty': amountReceive};
  }
  Map<String, dynamic> toJsonCurrent() {
    return {'sku_id': giftId, 'qty': amountCurrent};
  }


  @override
  String toString() {
    return 'GiftEntity{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  List<Object> get props => [giftId];

}
abstract class NormalGift {

}
abstract class OnTopGift {

}

// ignore: must_be_immutable
class Nen extends GiftEntity with NormalGift {
  Nen(
      {int giftId,
      String name,
      String image,
      int amountCurrent,
      int amountReceive, String assetGift})
      : super(
            giftId: giftId,
            name: name,
            image: image,
            amountReceive: amountReceive,
            amountCurrent: amountCurrent,
            assetGift: assetGift);

  @override
  String toString() {
    return 'Nen{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Nen clone() {
    return Nen(
      giftId: 1001,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      image: this.image,
      assetGift: this.assetGift,
    );
  }
}

// ignore: must_be_immutable
class Voucher extends GiftEntity with NormalGift {
  Voucher(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'Voucher{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Voucher clone() {
   return Voucher(giftId: 1002,
     amountCurrent: this.amountCurrent,
     amountReceive: this.amountReceive,
     name: this.name,
     assetGift: this.assetGift,
     image: this.image,);
  }
  Voucher setOver(){
    return Voucher(giftId: this.giftId,
      amountCurrent: 0,
      amountReceive: this.amountReceive,
      name: this.name,
      assetGift: this.assetGift,
      image: this.image,);
  }
}

// ignore: must_be_immutable
class StrongBowGift extends GiftEntity with NormalGift {
  StrongBowGift(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'StrongBowGift{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  StrongBowGift clone() {
    return StrongBowGift(giftId: 1003,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      assetGift: this.assetGift,
      image: this.image,);
  }
}

// ignore: must_be_immutable
class Pack4 extends GiftEntity with NormalGift{
  Pack4(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'Pack4{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Pack4 clone() {
   return Pack4(giftId: 1004,
     amountCurrent: this.amountCurrent,
     amountReceive: this.amountReceive,
     name: this.name,
     assetGift: this.assetGift,
     image: this.image,);
  }
}

// ignore: must_be_immutable
class Pack6 extends GiftEntity with NormalGift {
  Pack6(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'Pack6{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Pack6 clone() {
    return Pack6(giftId: 1005,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,assetGift: this.assetGift,
      image: this.image,);
  }
}

// ignore: must_be_immutable
class Alu extends GiftEntity with NormalGift {
  Alu(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'Alu{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Alu clone() {
    return Alu(giftId: 1006,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      assetGift: this.assetGift,
      image: this.image,);
  }
}

// ignore: must_be_immutable
class Magnum extends GiftEntity with NormalGift {
  Magnum(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'Magnum{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Magnum clone() {
   return Magnum(giftId: 1007,
     amountCurrent: this.amountCurrent,
     amountReceive: this.amountReceive,
     name: this.name,
     assetGift: this.assetGift,
     image: this.image,);
  }
}

// ignore: must_be_immutable
class TravelBags extends GiftEntity with OnTopGift {
  TravelBags(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'TravelBags{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  TravelBags clone() {
    return TravelBags(
      giftId: 28,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      assetGift: this.assetGift,
      image: this.image,);
  }
}

// ignore: must_be_immutable
class Glass extends GiftEntity with OnTopGift{
  Glass(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);

  @override
  String toString() {
    return 'Glass{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  Glass clone() {
    return Glass(giftId: 26,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      assetGift: this.assetGift,
      image: this.image,);
  }
}

// ignore: must_be_immutable
class CanvasBag extends GiftEntity  with OnTopGift {
  CanvasBag(
      {int giftId,
        String name,
        String image,
        int amountCurrent,
        int amountReceive, String assetGift})
      : super(
    giftId: giftId,
    name: name,
    image: image,
    amountReceive: amountReceive,
    amountCurrent: amountCurrent,
    assetGift: assetGift,);


  @override
  String toString() {
    return 'CanvasBag{giftId: $giftId, name: $name, image: $image, amountCurrent: $amountCurrent, amountReceive: $amountReceive, assetGift: $assetGift}';
  }

  @override
  CanvasBag clone() {
    return CanvasBag(
      giftId: 27,
      amountCurrent: this.amountCurrent,
      amountReceive: this.amountReceive,
      name: this.name,
      assetGift: this.assetGift,
      image: this.image,);
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

import 'gift_entity.dart';
part 'product_entity.g.dart';

@HiveType(typeId: 8 )
// ignore: must_be_immutable
class ProductEntity extends Equatable with HiveObject {
  @HiveField(0)
  final int productId;
  @HiveField(1)
  final String productName;
  @HiveField(2)
  final String imgUrl;
  @HiveField(3)
  int price;
  @HiveField(4)
  int count;
  TextEditingController controller = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode focus = FocusNode();

  ProductEntity({this.productId, this.productName, this.count, this.price, this.imgUrl});

  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    return [];
  }

  ProductEntity copyWith({int count, int price}){
    return null;
  }

  ProductEntity.internal(this.productId, this.productName, this.imgUrl){
    return ;
  }

  @override
  List<Object> get props => [productName, price, count];
}
// ignore: must_be_immutable
class Heineken extends ProductEntity {
  Heineken(
      {int productId, String productName, int count, int price, String imgUrl})
      : super(
      productId: productId,
      productName: productName,
      price: price,
      count: count,
      imgUrl: imgUrl);

  Heineken.internal(int count){
    this.count = count;
  }
  @override
  String toString() {
    return 'Heineken ${controller.text}';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = List<Gift>();
    if(count >= 2) {
      giftResult.add(Pack6.internal());
       List.generate(count-2 < 3 ? count-2 : 3, (index)  => giftResult.add(Wheel(id: index + 10)));
    }
    if(outlet.province == "HN" || outlet.province == "HCM"){
      if(count >= 1) {
        print('hcm');
         giftResult.add(StrongBowGift.internal());
      }
    }
    if(outlet.province != "HN" && outlet.province != "HCM"){
      if(count >= 1) {
        print("not hcm");
         giftResult.add(Nen.internal());
      }
    }
    return await Future.value(giftResult);
    // return list gift receive
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return Heineken(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price,);
  }
}
// ignore: must_be_immutable
class HeinekenNormal extends Heineken{
  HeinekenNormal(
      {int productId, String productName, int count, int price, String imgUrl })
      : super(
      productId: productId,
      productName: productName,
      price: price,
      count: count,
      imgUrl: imgUrl);

  HeinekenNormal.internal();

  @override
  ProductEntity copyWith({int count, int price}) {
    return HeinekenNormal(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Heineken0 extends Heineken{
  Heineken0({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  Heineken0.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return Heineken0(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class HeinekenSilver extends Heineken{
  HeinekenSilver({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  HeinekenSilver.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return HeinekenSilver(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Tiger extends ProductEntity{
  Tiger({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  Tiger.internal(int count){
    this.count = count;
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return Tiger( productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'Tiger';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async {
    List<Gift> giftResult = List<Gift>();
    if(count >= 2){
      giftResult.add(Pack4.internal());
      List.generate(count-2 < 3? count - 2 : 3, (index)  => giftResult.add(Wheel(id: index +20)));
    }
    if(count >= 1) {
        giftResult.add(Nen.internal());
      }
    return await Future.value(giftResult);
    // return list gift receive
  }
}
// ignore: must_be_immutable
class TigerNormal extends Tiger{
  TigerNormal({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  TigerNormal.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return TigerNormal(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class TigerCrystal extends Tiger{
  TigerCrystal({int productId, String productName, int count, int price, String imgUrl }) : super(productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  TigerCrystal.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return TigerCrystal( productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class StrongBow extends ProductEntity{
  StrongBow({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  StrongBow.internal(int count){
    this.count = count;
  }
  @override
  ProductEntity copyWith({int count, int price}) {
    return StrongBow(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'StrongBow';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = List<Gift>();
    if(outlet.province == "HN" || outlet.province == "HCM"){
      if(count >= 1) {
        giftResult.add(Nen.internal());
      }
      if(count >= 2){
        List.generate(count-1 < 4 ? count-1 : 4, (index)  => giftResult.add(Wheel(id: index +30)));
      }
    }
    return await Future.value(giftResult);
    // return list gift receive
  }
}
// ignore: must_be_immutable
class NormalBeer extends ProductEntity{
  NormalBeer({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  NormalBeer.internal(int count){
    this.count = count;
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return NormalBeer(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'NormalBeer';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = [];
    if(count >= 1) {
      giftResult.add(Voucher.internal());
    }
    if(count >= 2){
      List.generate(count-1 < 4 ? count-1 : 4, (index)  => giftResult.add(Wheel(id: index + 40)));
    }
    return await Future.value(giftResult);
  }
}
// ignore: must_be_immutable
class BiaViet extends NormalBeer{
  BiaViet({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  BiaViet.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return BiaViet(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Larue extends NormalBeer{
  Larue({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  Larue.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return Larue( productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Bivina extends NormalBeer{
  Bivina({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);
  Bivina.internal();
  @override
  ProductEntity copyWith({int count, int price}) {
    return Bivina(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}




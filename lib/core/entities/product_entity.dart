import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

import 'gift_entity.dart';
part 'product_entity.g.dart';

@HiveType(typeId: 8 )
// ignore: must_be_immutable
  class ProductEntity extends HiveObject {
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
  int buyQty;
  TextEditingController controller = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode focus = FocusNode();

  ProductEntity({this.productId, this.productName, this.count, this.price, this.imgUrl}) {
    buyQty = 0;
    count = count ?? 0;
    price = price ?? 0;
    countController.text = count.toString();
    priceController.text = price.toString();

  }
  factory ProductEntity.create(ProductEntity productEntity){
      switch(productEntity.productId){
  case 8: return HeinekenNormal(
  productId: productEntity.productId,
  productName: productEntity.productName,
  count: productEntity.count,
  price: productEntity.price,
  imgUrl: productEntity.imgUrl,
  );
  case 9: return Heineken0(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 10: return HeinekenSilver(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 11: return TigerNormal(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 12: return TigerCrystal(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 13: return StrongBow(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 14: return Larue(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 15: return BiaViet(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  case 16: return Bivina(
    productId: productEntity.productId,
    productName: productEntity.productName,
    count: productEntity.count,
    price: productEntity.price,
    imgUrl: productEntity.imgUrl,
  );
  }
  return productEntity;
  }
  //  switch(fields[0] as int){
//  case 8: return HeinekenNormal(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 9: return Heineken0(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 10: return HeinekenSilver(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 11: return TigerNormal(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 12: return TigerCrystal(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  c/ase 13: return StrongBow(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 14: return Larue(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 15: return BiaViet(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//  case 16: return Bivina(
//  productId: fields[0] as int,
//  productName: fields[1] as String,
//  count: fields[4] as int ?? 0,
//  price: fields[3] as int ?? 0,
//  imgUrl: fields[2] as String,
//  );
//
//  }

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    switch(json['id'] as int){
      case 8 : return HeinekenNormal(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 9 : return Heineken0(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 10 : return HeinekenSilver(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 11 : return TigerNormal(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 12 : return TigerCrystal(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 13 : return StrongBow(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 14 : return Larue(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 15 : return BiaViet(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
      case 16 : return Bivina(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
      );
    }
    return ProductEntity(
        productId: json['id'] as int,
        productName: json['name'] as String,
        imgUrl: json["img_url"] as String,
    );

  }
  Map<String, dynamic> toBuyQtyJson(){
    return {
      'sku_id': productId,
      'qty': buyQty,
    };
  }


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
  String toString() {
    return 'ProductEntity{productId: $productId, productName: $productName, imgUrl: $imgUrl, price: $price, count: $count';
  }

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
    this.buyQty = count;
  }
  @override
  String toString() {
    return 'Heineken ${buyQty}';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = List<Gift>();
    if(buyQty >= 2) {
      giftResult.add(Pack6());
       List.generate(buyQty-2 < 3 ? buyQty-2 : 3, (index)  => giftResult.add(Wheel(id: index + 10)));
    }
    if(outlet.province == "HN" || outlet.province == "HCM"){
      if(buyQty >= 1) {
        print('hcm');
         giftResult.add(StrongBowGift());
      }
    }
    if(outlet.province != "HN" && outlet.province != "HCM"){
      if(buyQty >= 1) {
        print("not hcm");
         giftResult.add(Nen());
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


  @override
  String toString() {
    return 'HeinekenNormal{buy: $buyQty, qty: $count, price: $price }';
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return HeinekenNormal(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Heineken0 extends Heineken{
  Heineken0({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);


  @override
  String toString() {
    return 'Heineken0{buy: $buyQty, qty: $count, price: $price }';
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return Heineken0(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class HeinekenSilver extends Heineken{
  HeinekenSilver({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  @override
  String toString() {
    return 'HeinekenSilver{buy: $buyQty, qty: $count, price: $price }';
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return HeinekenSilver(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Tiger extends ProductEntity{
  Tiger({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  Tiger.internal(int count){
    this.buyQty = count;
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return Tiger( productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'Tiger{$buyQty}';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async {
    List<Gift> giftResult = List<Gift>();
    if(buyQty >= 2){
      giftResult.add(Pack4());
      List.generate(buyQty-2 < 3? buyQty - 2 : 3, (index)  => giftResult.add(Wheel(id: index +20)));
    }
    if(buyQty >= 1) {
        giftResult.add(Nen());
      }
    return await Future.value(giftResult);
    // return list gift receive
  }
}
// ignore: must_be_immutable
class TigerNormal extends Tiger{
  TigerNormal({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);


  @override
  String toString() {
    return 'TigerNormal{$count,$price}';
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return TigerNormal(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class TigerCrystal extends Tiger{
  TigerCrystal({int productId, String productName, int count, int price, String imgUrl }) : super(productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  @override
  String toString() {
    return 'TigerCrystal{buy: $buyQty, qty: $count, price: $price }';
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return TigerCrystal( productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class StrongBow extends ProductEntity{
  StrongBow({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  StrongBow.internal(int count){
    this.buyQty = count;
  }
  @override
  ProductEntity copyWith({int count, int price}) {
    return StrongBow(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'StrongBow{buy: $buyQty, qty: $count, price: $price }';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    print(1);
    List<Gift> giftResult = [];
    if(outlet.province == "HN" || outlet.province == "HCM"){
      if(buyQty >= 1) {
        print(1);
        giftResult.add(Nen());
      }
      if(buyQty >= 2){
        print(2);
        List.generate(buyQty-1 < 4 ? buyQty-1 : 4, (index)  => giftResult.add(Wheel(id: index + 30)));
      }
    }else{
      List.generate(buyQty < 5 ? buyQty : 5, (index)  => giftResult.add(Wheel(id: index + 110)));
    }

    return await Future.value(giftResult);
    // return list gift receive
  }
}
// ignore: must_be_immutable
class NormalBeer extends ProductEntity{
  NormalBeer({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  NormalBeer.internal(int count){
    this.buyQty = count;
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return NormalBeer(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }

  @override
  String toString() {
    return 'NormalBeer{$buyQty}';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = [];
    if(buyQty >= 1) {
      giftResult.add(Voucher());
    }
    if(buyQty >= 2){
      List.generate(buyQty-1 < 4 ? buyQty-1 : 4, (index)  => giftResult.add(Wheel(id: index + 40)));
    }
    return await Future.value(giftResult);
  }
}
// ignore: must_be_immutable
class BiaViet extends NormalBeer{
  BiaViet({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  @override
  String toString() {
    return 'BiaViet{buy: $buyQty, qty: $count, price: $price }';
  }

  @override
  ProductEntity copyWith({int count, int price}) {
    return BiaViet(productName: this.productName, productId: this.productId, imgUrl: this.imgUrl, count: count ?? this.count, price: price ?? this.price);
  }
}
// ignore: must_be_immutable
class Larue extends NormalBeer{
  Larue({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  @override
  String toString() {
    return 'Larue{buy: $buyQty, qty: $count, price: $price }';
  }

}
// ignore: must_be_immutable
class Bivina extends NormalBeer {
  Bivina(
      {int productId, String productName, int count, int price, String imgUrl })
      : super(productId: productId,
      productName: productName,
      price: price,
      count: count,
      imgUrl: imgUrl);

  @override
  String toString() {
    return 'Bivina{buy: $buyQty, qty: $count, price: $price }';
  }
}
  // ignore: must_be_immutable
  class StrongBowPack6 extends ProductEntity{
  StrongBowPack6({int productId, String productName, int count, int price, String imgUrl }) : super( productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = [];
    if(buyQty >= 1){
      List.generate(buyQty < 5 ? buyQty : 5, (index)  => giftResult.add(StrongBowWheel(id: index + 200)));
    }
    return await Future.value(giftResult);
  }

  @override
  String toString() {
    return 'StrongBowPack6{buy: $buyQty, qty: $count, price: $price }';
  }


}




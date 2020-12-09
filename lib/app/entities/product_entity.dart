import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/app/entities/gift_entity.dart';
import 'package:sp_2021/app/entities/set_gift_entity.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/outlet_info.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

import '../../di.dart';

@immutable
abstract class ProductEntity extends Equatable {
  final int productId;
  final String productName;
  final String imgUrl;
  final int brandId;
  int price;
  int count;
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();

  ProductEntity({this.productId, this.productName, this.count, this.price, this.imgUrl, this.brandId});

  Future<List<Gift>> getGift({LoginEntity outlet}) ;

  void updatePrice(){
    this.price = this.controller.text as int;
  }
  void updateCount(){
    this.count = this.controller.text as int;
  }

  @override
  List<Object> get props => [productName, price, count];
}
class RivalProductEntity {
  final int price;
  final String name;
  TextEditingController controller = TextEditingController();

  RivalProductEntity({this.name, this.price});

}
class Heneiken extends ProductEntity {
  Heneiken(
      {int productId, int brandId, String productName, int count, int price, String imgUrl})
      : super(brandId: brandId,
      productId: productId,
      productName: productName,
      price: price,
      count: count,
      imgUrl: imgUrl);

  Heneiken.internal(int count){
    this.count = count;
  }


  @override
  String toString() {
    return 'Heineken{$count}';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = List<Gift>();
    if(count >= 2) {
      print('in it');
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
}
class HeneikenNormal extends Heneiken {
  HeneikenNormal(
      {int productId, int brandId, String productName, int count, int price, String imgUrl })
      : super(brandId: brandId,
      productId: productId,
      productName: productName,
      price: price,
      count: count,
      imgUrl: imgUrl);
}
class Heneiken0 extends Heneiken{
  Heneiken0({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}
class HeneikenSilver extends Heneiken{
  HeneikenSilver({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}
class Tiger extends ProductEntity{
  Tiger({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  Tiger.internal(int count){
    this.count = count;
  }


  @override
  String toString() {
    return 'Tiger{$count}';
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
class TigerNormal extends Tiger{
  TigerNormal({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}
class TigerCrystal extends Tiger{
  TigerCrystal({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}
class StrongBow extends ProductEntity{
  StrongBow({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  StrongBow.internal(int count){
    this.count = count;
  }


  @override
  String toString() {
    return 'StrongBow{$count}';
  }

  @override
  Future<List<Gift>> getGift({LoginEntity outlet}) async{
    List<Gift> giftResult = List<Gift>();
    if(outlet.province == "HN" || outlet.province == "HCM"){
      if(count >= 1) {
        giftResult.add(Nen.internal());
      }
      if(count >= 2){
        List.generate(count-2 < 4 ? count-2 : 4, (index)  => giftResult.add(Wheel(id: index +30)));
      }
    }
    return await Future.value(giftResult);
    // return list gift receive
  }
}
class NormalBeer extends ProductEntity{
  NormalBeer({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

  NormalBeer.internal(int count){
    this.count = count;
  }

  @override
  String toString() {
    return 'NormalBeer{$count}';
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
class BiaViet extends NormalBeer{
  BiaViet({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}
class Larue extends NormalBeer{
  Larue({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}
class Bivina extends NormalBeer{
  Bivina({int productId, int brandId, String productName, int count, int price, String imgUrl }) : super( brandId: brandId, productId: productId, productName: productName, price: price, count: count, imgUrl: imgUrl);

}




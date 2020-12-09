import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/app/entities/gift_entity.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/app/entities/set_gift_entity.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/gifts_receive.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

import '../../../../di.dart';

class ReceiveGiftRepositoryImpl implements ReceiveGiftRepository {
 final SecureStorage storage;

  ReceiveGiftRepositoryImpl({this.storage});
  @override
  Future<Either<Failure, GiftCanReceive>> ExportGift({
      List<ProductEntity> products, CustomerEntity customer}) async {
    List<Gift> resultGift = <Gift>[];
    // get set gift current
    var setGift = SetGiftEntity.giftsCurrent;
    // get all Gift can receive
    LoginEntity outlet = await storage.readUser(key: OUTLET_IN_STORAGE);
    resultGift = await getGift(products, outlet);
    // fixed length of result Gift
    int len = resultGift.length;
    resultGift = len >= customer.inTurn ? resultGift.sublist(0,  customer.inTurn) : resultGift.sublist(0, len);
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    //* UseCase Tiger & StrongBow => 2 Candle*//
    //* remove one candle*//
    if((resultGift.where((element) => element is Nen)..toList()).length > 1){
      resultGift.removeAt(resultGift.lastIndexOf(Nen.internal()));
    }
    // mapping vs current SetGift
    // if set not enough then change it to Wheel
    // else update amount
    resultGift.forEach((gift){
      if (gift is Nen) {
        if(setGift.firstWhere((element) => element is Nen).amountCurrent > 0 ) {

//          int index = resultGift.indexWhere((element) => element is Nen);
//          resultGift.removeWhere((element)=> element is Nen);
//          resultGift.insert(index, Wheel(id:50));
          setGift = setGift.map((e) => e is Nen ? e = e.copyWith(current: e.amountCurrent-1) :e = e).toList();
        }
        if (setGift.whereType<Nen>().first.amountCurrent < 0 ) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id:50));
        }
      }
      if (gift is Voucher) {
        if(setGift.whereType<Voucher>().first.amountCurrent > 0 ) {
          setGift = setGift.map((e) => e is Voucher ?e = e.copyWith(current: e.amountCurrent-1) :e = e).toList();
        }
        if (setGift.whereType<Voucher>().first.amountCurrent < 0 ) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id:60));
        }
      }
      if (gift is StrongBowGift) {
        if(setGift.whereType<StrongBowGift>().first.amountCurrent > 0 ) {
          setGift = setGift.map((e) => e is StrongBowGift ? e = e.copyWith(current: e.amountCurrent-1) : e = e).toList();
        }
        if (setGift.whereType<StrongBowGift>().first.amountCurrent < 0 ) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id:70));
        }
      }
      if (gift is Pack6) {
        if(setGift.whereType<Pack6>().first.amountCurrent > 0 ) {
          setGift = setGift.map((e) => e is Pack6 ? e = e.copyWith(current: e.amountCurrent-1) :e = e).toList();
        }
        if (setGift.whereType<Pack6>().first.amountCurrent < 0 ) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id:80));
        }
      }
      if (gift is Pack4) {
        if(setGift.whereType<Pack4>().first.amountCurrent > 0 ) {
          setGift = setGift.map((e) => e is Pack4 ? e = e.copyWith(current: e.amountCurrent-1) :e = e).toList();
        }
        if (setGift.whereType<Pack4>().first.amountCurrent < 0 ) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id:90));
        }
      }
    });
    //resort
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    print('result: $resultGift');
    print('set: $setGift');
    // update setGift current
    return Right(GiftCanReceive(giftReceives: resultGift));
  }
  Future<List<Gift>> getGift(List<ProductEntity> products, LoginEntity outlet){
    List<Gift> result = [];
    products.forEach((product) async {
      List<Gift> giftOfProduct = await product.getGift(outlet: outlet);
      print(giftOfProduct);
      result.addAll(giftOfProduct);
    });
    return Future.value(result);
  }
}

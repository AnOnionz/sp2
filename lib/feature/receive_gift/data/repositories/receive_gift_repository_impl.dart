import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_wheel_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

import '../../../../di.dart';

class ReceiveGiftRepositoryImpl implements ReceiveGiftRepository {
  final SecureStorage storage;
  final DashBoardLocalDataSource local;

  ReceiveGiftRepositoryImpl({this.storage, this.local});
  @override
  Future<Either<Failure, HandleGiftEntity>> handleGift(
      {List<ProductEntity> products,
      CustomerEntity customer,
      SetGiftEntity setCurrent}) async {
    List<Gift> resultGift = <Gift>[];
    //check set current
    setCurrent = setCurrent.gifts.where((element) => element.amountCurrent > 0).toList().isEmpty ? local.fetchNewSetGift(setCurrent.index+1) : setCurrent;
    // get set gift current
    final gifts = local.fetchGift();
    // get all Gift can receive
    LoginEntity outlet =
        await storage.readUser(key: OUTLET_IN_STORAGE); // check province
    resultGift = await getGift(products, outlet);
    print("it: $resultGift");
    resultGift.map((e) => gifts[e.id - 1]);
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    // fixed length of result Gift
    int len = resultGift.length;
    resultGift = len >= customer.inTurn
        ? resultGift.sublist(0, customer.inTurn)
        : resultGift.sublist(0, len);

    //* UseCase (HCM&HCM) Tiger & StrongBow ||(Province) Heineken & Tiger => 2 Candle*//
    //* remove one candle*//
    if ((resultGift.where((element) => element is Nen)..toList()).length > 1) {
      int index = resultGift.lastIndexOf(Nen.internal());
      resultGift.removeAt(index);
      resultGift.insert(index, Wheel(id: 100));
    }
    // mapping vs current SetGift
    // if set not enough then change it to Wheel
    // else update amount
    resultGift.forEach((gift) {
      if (gift is Nen) {
        if (setCurrent.gifts
                .firstWhere((element) => element is Nen)
                .amountCurrent > 0) {
          setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => gift.giftId == e.giftId ? e.downCurrent() : e)
                  .toList());
        }
        else {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 50));
        }
      }
      if (gift is Voucher) {
        if (setCurrent.gifts.whereType<Voucher>().first.amountCurrent > 0) {
          setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => gift.giftId == e.giftId ? e.downCurrent() : e)
                  .toList());
        }
        else {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 60));
        }
      }
      if (gift is StrongBowGift) {
        if (setCurrent.gifts.whereType<StrongBowGift>().first.amountCurrent > 0) {
          setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => gift.giftId == e.giftId ? e.downCurrent() : e)
                  .toList());
        }
        else {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 70));
        }
      }
      if (gift is Pack4) {
        if (setCurrent.gifts.whereType<Pack4>().first.amountCurrent > 0) {
          setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => gift.giftId == e.giftId ? e.downCurrent() : e)
                  .toList());
        }
        else {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 90));
        }
      }
      if (gift is Pack6) {
        if (setCurrent.gifts.whereType<Pack6>().first.amountCurrent > 0) {
          setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => gift.giftId == e.giftId ? e.downCurrent() : e)
                  .toList());
        }
        else{
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 80));
        }
      }
    });
    //resort
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    print("will receive: $resultGift");
    // update setGift current
    return Right(HandleGiftEntity(gifts: resultGift, setCurrent: setCurrent));
  }

  Future<List<Gift>> getGift(
      List<ProductEntity> products, LoginEntity outlet) async {
    List<Gift> result = [];
    products.forEach((product) async {
      final giftOfProduct = await product.getGift(outlet: outlet);
      result.addAll(giftOfProduct);
    });
    return result;
  }

  @override
  Future<Either<Failure, HandleWheelEntity>> handleWheel(
      {List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async {
    List<GiftEntity> lucky = [];
    List<GiftEntity> noLucky = [];
    // check current set is empty
    setCurrent = setCurrent.gifts.where((element) => element.amountCurrent > 0).toList().isEmpty ? local.fetchNewSetGift(setCurrent.index+1) : setCurrent;
    // fetch gift > 0 in set gift
    List<GiftEntity> gifts =
        setCurrent.gifts.where((element) => element.amountCurrent > 0).toList();
    // lucky
    print("received: $giftReceived");
    gifts.forEach((gift) {
      // gift not in gift gift received
      if (checkContain(gift, giftReceived) == false) {
        lucky.add(gift);
      }
      if (checkContain(gift, giftReceived) == true) {
        noLucky.add(gift);
      }
    });
    if (lucky.isEmpty) {
      if (noLucky.isNotEmpty) {
        lucky = noLucky;
      }
      if (noLucky.isEmpty) {
        int index = setCurrent.index+1;
        setCurrent = local.fetchNewSetGift(index);
        gifts.forEach((gift) {
          // gift not in gift gift received
          if (checkContain(gift, giftReceived) == false) {
            lucky.add(gift);
          }
          if (checkContain(gift, giftReceived)) {
            noLucky.add(gift);
          }
        });
      }
    }
    // UPDATE SET TEMP CURRENT
    return Right(HandleWheelEntity(setCurrent: setCurrent, lucky: lucky));
  }

  bool checkContain(GiftEntity gift, List<GiftEntity> giftsReceived) {
    return giftsReceived.map((e) => e.giftId).contains(gift.giftId);
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_remote_datasource.dart';

abstract class DashBoardLocalDataSource {
  bool checkLocalHasData();
  List<ProductEntity> fetchProduct();
  List<RivalProductEntity> fetchRivalProduct();
  List<GiftEntity> fetchGift();
  List<SetGiftEntity> fetchSetGift();
  SetGiftEntity fetchSetGiftCurrent();
  SetGiftEntity fetchNewSetGift(int index);
  Future<void> cacheProducts({List<ProductEntity> products});
  Future<void> cacheRivalProducts({List<RivalProductEntity> products});
  Future<void> cacheGifts({List<GiftEntity> gifts});
  Future<void> cacheSetGifts({List<SetGiftEntity> setGifts});
  Future<void> cacheSetGiftCurrent({SetGiftEntity setGiftEntity});
}

class DashBoardLocalDataSourceImpl implements DashBoardLocalDataSource {
  @override
  List<GiftEntity> fetchGift() {
    Box<GiftEntity> box = Hive.box<GiftEntity>(GIFT_BOX);
    return box.values.toList();
  }

  @override
  List<ProductEntity> fetchProduct() {
    Box<ProductEntity> box = Hive.box<ProductEntity>(PRODUCT_BOX);
    box.values.toList().forEach((element) {
      element.controller = TextEditingController();
      element.countController = TextEditingController();
      element.priceController = TextEditingController();
    });
    return box.values.toList().map((e) {
      switch (e.productId){
        case 8 : return HeinekenNormal(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 9 : return Heineken0(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 10 : return HeinekenSilver(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 11: return TigerNormal(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 12 : return TigerCrystal(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 13 : return StrongBow(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 14 : return Larue(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 15 : return BiaViet(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
        case 16 : return Bivina(productId: e.productId, productName: e.productName, price: e.price, count: e.count, imgUrl: e.imgUrl);
      }
    }).toList();
  }

  @override
  List<RivalProductEntity> fetchRivalProduct() {
    Box<RivalProductEntity> box = Hive.box<RivalProductEntity>(RIVAL_PRODUCT_BOX);
    box.values.toList().forEach((element) {
      element.priceController = TextEditingController();
    });
    return box.values.toList();
  }

  @override
  List<SetGiftEntity> fetchSetGift() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    return box.values.toList().map((e) {
      return e.fromDB(e);
    }).toList();
  }

  @override
  SetGiftEntity fetchSetGiftCurrent() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_CURRENT_BOX);
    final set = box.get(CURRENT_SET_GIFT);
    return set.fromDB(set);
  }

  @override
  SetGiftEntity fetchNewSetGift(int index) {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    final set = box.get(index);
    return set.fromDB(set);
  }
  @override
  bool checkLocalHasData() {
    Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    Box<SetGiftEntity> currentBox = Hive.box<SetGiftEntity>(SET_GIFT_CURRENT_BOX);
    Box<RivalProductEntity> rivalBox = Hive.box<RivalProductEntity>(RIVAL_PRODUCT_BOX);
    Box<ProductEntity> productBox = Hive.box<ProductEntity>(PRODUCT_BOX);
    Box<GiftEntity> giftBox = Hive.box<GiftEntity>(GIFT_BOX);
    return setGiftBox.isNotEmpty && giftBox.isNotEmpty && currentBox.isNotEmpty && rivalBox.isNotEmpty && productBox.isNotEmpty;
  }

  @override
  Future<void> cacheGifts({List<GiftEntity> gifts}) async {
    Box<GiftEntity> box = Hive.box<GiftEntity>(GIFT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(gifts);
  }

  @override
  Future<void> cacheProducts({List<ProductEntity> products}) async {
    Box<ProductEntity> box = Hive.box<ProductEntity>(PRODUCT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(products);
  }

  @override
  Future<void> cacheRivalProducts({List<RivalProductEntity> products}) async {
    Box<RivalProductEntity> box =
        Hive.box<RivalProductEntity>(RIVAL_PRODUCT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(products);
  }

  @override
  Future<void> cacheSetGiftCurrent({SetGiftEntity setGiftEntity}) async {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_CURRENT_BOX);
    if (box.containsKey(CURRENT_SET_GIFT)) {
      await box.delete(CURRENT_SET_GIFT);
    }
    await box.put(CURRENT_SET_GIFT, setGiftEntity);
  }

  @override
  Future<void> cacheSetGifts({List<SetGiftEntity> setGifts}) async {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(setGifts);
  }




}

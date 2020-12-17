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
    return box.values.toList();
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
    return box.values.toList();
  }

  @override
  SetGiftEntity fetchSetGiftCurrent() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_CURRENT_BOX);
    return box.get(CURRENT_SET_GIFT);
  }

  @override
  SetGiftEntity fetchNewSetGift(int index) {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    return box.getAt(index);
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

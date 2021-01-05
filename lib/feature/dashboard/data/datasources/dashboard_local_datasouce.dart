import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/today_data_entity.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

abstract class DashBoardLocalDataSource {
  bool get loadInitDataToLocal;
  int get indexLast;
  bool get isSetOver;
  DataTodayEntity get dataToday;
  List<ProductEntity> fetchProduct();
  List<RivalProductEntity> fetchRivalProduct();
  List<GiftEntity> fetchGift();
  List<GiftEntity> fetchSBGift();
  List<SetGiftEntity> fetchSetGift();
  SetGiftEntity fetchSetGiftCurrent();
  SetGiftEntity fetchNewSetGift(int index);
  SetGiftEntity fetchNewSBSetGift(int index);
  Future<void> cacheDataToday(
      {bool highLight, bool checkIn, bool checkOut, bool inventory, HighlightCacheEntity highlightCacheEntity, InventoryEntity inventoryEntity});
  Future<void> cacheProducts({List<ProductEntity> products});
  Future<void> cacheRivalProducts({List<RivalProductEntity> products});
  Future<void> cacheGifts({List<GiftEntity> gifts});
  Future<void> cacheSetGifts({List<SetGiftEntity> setGifts});
  Future<void> cacheSetGiftCurrent({SetGiftEntity setGiftEntity});
}

class DashBoardLocalDataSourceImpl implements DashBoardLocalDataSource {

  @override
  DataTodayEntity get dataToday {
    Box<DataTodayEntity> box = Hive.box(AuthenticationBloc.outlet.code + DATA_DAY);
    final defaultData = DataTodayEntity(
        checkIn: false, checkOut: false, highLight: false, inventory: false, highlightCached: null, inventoryEntity: null);
    final result = box.get(MyDateTime.today ,defaultValue: defaultData);
    if (result == defaultData) {
      box.put(MyDateTime.today, result);
    }
    return result;
  }

  @override
  bool get loadInitDataToLocal {
    Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    Box<SetGiftEntity> currentBox = Hive.box<SetGiftEntity>(SET_GIFT_CURRENT_BOX);
    Box<RivalProductEntity> rivalBox = Hive.box<RivalProductEntity>(RIVAL_PRODUCT_BOX);
    Box<ProductEntity> productBox = Hive.box<ProductEntity>(PRODUCT_BOX);
    Box<GiftEntity> giftBox = Hive.box<GiftEntity>(GIFT_BOX);
    return setGiftBox.isEmpty ||
        giftBox.isEmpty ||
        currentBox.isEmpty ||
        rivalBox.isEmpty ||
        productBox.isEmpty ;
  }

  @override
  List<GiftEntity> fetchGift() {
    Box<GiftEntity> box = Hive.box<GiftEntity>(GIFT_BOX);
    return box.values.toList();
  }

  @override
  List<ProductEntity> fetchProduct() {
    Box<ProductEntity> box = Hive.box<ProductEntity>(PRODUCT_BOX);
    box.values.toList().forEach((element) {
      element.buyQty = 0;
      element.controller = TextEditingController();
      element.countController = TextEditingController();
      element.priceController = TextEditingController();
    });
    return box.values.toList();
  }

  @override
  List<RivalProductEntity> fetchRivalProduct() {
    Box<RivalProductEntity> box =
        Hive.box<RivalProductEntity>(RIVAL_PRODUCT_BOX);
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
    final setCurrent = box.get(CURRENT_SET_GIFT);
    return SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts);
  }

  @override
  SetGiftEntity fetchNewSetGift(int index) {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    final set = box.get(index, defaultValue: null);
    return set == null ? null : SetGiftEntity(index: set.index, gifts: set.gifts);
  }

  @override
  SetGiftEntity fetchNewSBSetGift(int index) {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(SET_GIFT_STRONGBOW_BOX);
    return box.get(index);
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

  @override
  Future<void> cacheDataToday(
      {bool highLight, bool checkIn, bool checkOut, bool inventory, HighlightCacheEntity highlightCacheEntity, InventoryEntity inventoryEntity}) async {
    final data = dataToday;
    data.checkOut = checkOut ?? data.checkOut;
    data.checkIn = checkIn ?? data.checkIn;
    data.inventory = inventory ?? data.inventory;
    data.highLight = highLight ?? data.highLight;
    data.highlightCached = highlightCacheEntity ?? data.highlightCached;
    data.inventoryEntity = inventoryEntity ?? data.inventoryEntity;
    await data.save();
    print(data);
  }

  @override
  int get indexLast {
    Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(SET_GIFT_BOX);
    return setGiftBox.values.toList().last.index;
  }

  @override
  bool get isSetOver {
    final setCurrent = fetchSetGiftCurrent();
    final sum = setCurrent.gifts.fold(
        0, (previousValue, element) => previousValue + element.amountCurrent);
    return setCurrent.index == indexLast && sum == 0 ;

    }

  @override
  List<GiftEntity> fetchSBGift() {
    Box<GiftEntity> box = Hive.box<GiftEntity>(GIFT_BOX);
    return box.values.toList();
  }

}

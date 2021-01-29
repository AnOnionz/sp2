import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:sp_2021/feature/dashboard/domain/entities/kpi_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';


abstract class DashBoardLocalDataSource {
  Stream<KpiEntity> get kpiStream;
  bool get loadInitDataToLocal;
  int get indexLast;
  bool get isSetOver;
  int get sbIndexLast;
  bool get isSetSBOver;
  bool get isChangeSet;
  void cacheChangedSet(bool value);
  DataTodayEntity get dataToday;
  List<ProductEntity> fetchProduct();
  List<RivalProductEntity> fetchRivalProduct();
  List<RivalProductEntity> fetchAvailableRivalProduct();
  List<GiftEntity> fetchGift();
  List<GiftEntity> fetchGiftStrongbow();
  List<SetGiftEntity> fetchSetGift();
  SetGiftEntity fetchSetGiftCurrent();
  List<SetGiftEntity> fetchSBSetGift();
  SetGiftEntity fetchSetGiftSBCurrent();
  SetGiftEntity fetchNewSetGift(int index);
  SetGiftEntity fetchNewSBSetGift(int index);
  KpiEntity fetchKpi();
  Future<void> updateKpi(List<dynamic> products);
  Future<void> cacheDataToday(
      {bool highLight, bool checkIn, bool checkOut, bool inventory,List<dynamic> salePrice, List<dynamic> rivalSalePrice, HighlightCacheEntity highlightCacheEntity, InventoryEntity inventoryEntity, CustomerGiftEntity customerGiftEntity});
  Future<void> cacheProducts({List<ProductEntity> products});
  Future<void> cacheRivalProducts({List<RivalProductEntity> products});
  Future<void> cacheGiftsStrongbow({List<GiftEntity> gifts});
  Future<void> cacheGifts({List<GiftEntity> gifts});
  Future<void> cacheSetGifts({List<SetGiftEntity> setGifts});
  Future<void> cacheSetGiftCurrent({SetGiftEntity setGiftEntity});
  Future<void> cacheSBSetGifts({List<SetGiftEntity> setGifts});
  Future<void> cacheSetGiftSBCurrent({SetGiftEntity setGiftEntity});
  Future<void> cacheKpi({KpiEntity kpi});
}

class DashBoardLocalDataSourceImpl implements DashBoardLocalDataSource {
  final SharedPreferences sharedPrefer;
  // ignore: close_sinks
  final StreamController<KpiEntity> _streamController = StreamController.broadcast();
  String todayStr = DateFormat.yMd().format(MyDateTime.day);

  DashBoardLocalDataSourceImpl({this.sharedPrefer});


  @override
  DataTodayEntity get dataToday {
    Box<DataTodayEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + DATA_DAY);
    DataTodayEntity defaultData = DataTodayEntity(checkIn: false, checkOut: false, highLight: false, inventory: false, highlightCached: null, inventoryEntity: null, rivalSalePrice: null, salePrice: null, receiveGift: null);
    final result = box.get(MyDateTime.today ,defaultValue: defaultData);
    if (result == defaultData) {
      box.put(MyDateTime.today, result);
    }
    return result;
  }
  
  @override
  Future<void> cacheDataToday(
      {bool highLight, bool checkIn, bool checkOut, bool inventory, List<dynamic> salePrice, List<dynamic> rivalSalePrice, HighlightCacheEntity highlightCacheEntity, InventoryEntity inventoryEntity, CustomerGiftEntity customerGiftEntity}) async {
    final data = dataToday;
    data.checkOut = checkOut ?? data.checkOut;
    data.checkIn = checkIn ?? data.checkIn;
    data.inventory = inventory ?? data.inventory;
    data.highLight = highLight ?? data.highLight;
    data.highlightCached = highlightCacheEntity ?? data.highlightCached;
    data.inventoryEntity = inventoryEntity ?? data.inventoryEntity;
    data.salePrice = salePrice ?? data.salePrice;
    data.rivalSalePrice = rivalSalePrice ?? data.rivalSalePrice;
    data.receiveGift = data.receiveGift ?? [];
    if(customerGiftEntity!=null){
      data.receiveGift.add(customerGiftEntity);
    }
    await data.save();
    //sharedPrefer.setString(MyDateTime.today, jsonEncode(data.toJson()));
    print(data);
  }
  @override
  Stream<KpiEntity> get kpiStream => _streamController.stream;

  @override
  bool get loadInitDataToLocal {
    Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
   // Box<SetGiftEntity> setGiftSBBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
    Box<SetGiftEntity> currentBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
    Box<RivalProductEntity> rivalBox = Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
    Box<ProductEntity> productBox = Hive.box<ProductEntity>(AuthenticationBloc.outlet.id.toString() + PRODUCT_BOX);
    Box<GiftEntity> giftBox = Hive.box<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_BOX);
    //Box<GiftEntity> giftStrongBowBox = Hive.box<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_STRONGBOW_BOX);
    return setGiftBox.isEmpty ||
        giftBox.isEmpty ||
        currentBox.isEmpty ||
        rivalBox.isEmpty ||
        productBox.isEmpty ;
  }

  @override
  List<GiftEntity> fetchGift() {
    Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_BOX);
    return box.values.toList();
  }
  @override
  List<GiftEntity> fetchGiftStrongbow() {
    Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_STRONGBOW_BOX);
    return box.values.toList();
  }

  @override
  List<ProductEntity> fetchProduct() {
    Box<ProductEntity> box = Hive.box<ProductEntity>(AuthenticationBloc.outlet.id.toString() + PRODUCT_BOX);
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
        Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
    return box.values.toList();
  }
  @override
  List<RivalProductEntity> fetchAvailableRivalProduct() {
    Box<RivalProductEntity> box =
    Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
    box.values.toList().forEach((element) {
      element.priceController = TextEditingController();
      element.save();
    });
    return box.values.toList().where((element) => element.isAvailable == true).toList();
  }

  @override
  List<SetGiftEntity> fetchSetGift() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
    return box.values.toList();
  }
  @override
  List<SetGiftEntity> fetchSBSetGift() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
    return box.values.toList();
  }

  @override
  SetGiftEntity fetchSetGiftCurrent() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
    SetGiftEntity setCurrent = box.get(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT);
    final lastDay = DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(AuthenticationBloc.outlet.endPromotion*1000)).toString();
    if (setCurrent != null) {
      setCurrent = SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts);
      if(todayStr == lastDay){
        setCurrent =  SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts.map((e) => e is Voucher ? e.setOver(): e).toList());
      }
    }else{
      setCurrent = fetchNewSetGift(1);
    }
    return setCurrent;
  }

  @override
  SetGiftEntity fetchSetGiftSBCurrent() {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
    SetGiftEntity setCurrent = box.get(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW, defaultValue: null);
    if (setCurrent != null) {
      setCurrent = SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts);
    }else{
      setCurrent = AuthenticationBloc.outlet.province =='HN_HCM' ? fetchNewSBSetGift(1) : null;
    }
    return setCurrent;

  }

  @override
  SetGiftEntity fetchNewSetGift(int index) {
    //Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
    final all = fetchSetGift();
    SetGiftEntity set = all.firstWhere((element) => element.index == index, orElse: ()=> null);
    final lastDay = DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(AuthenticationBloc.outlet.endPromotion*1000)).toString();
    print("new set:$set");
    if(set != null) {
      set = SetGiftEntity(index: set.index, gifts: set.gifts);
      cacheChangedSet(true);
      if(todayStr == lastDay){
        set =  SetGiftEntity(index: set.index, gifts: set.gifts.map((e) => e is Voucher ? e.setOver(): e).toList());
      }
    }
    return set;
  }

  @override
  SetGiftEntity fetchNewSBSetGift(int index) {
    //Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
    final all = fetchSBSetGift();
    SetGiftEntity set = all.firstWhere((element) => element.index == index, orElse: ()=> null);
    print("new set:$set");
    if(set != null) {
      set = SetGiftEntity(index: set.index, gifts: set.gifts);
      cacheChangedSet(true);
    }
    return set;
  }

  @override
  Future<void> cacheGifts({List<GiftEntity> gifts}) async {
    Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(gifts);
  }
  @override
  Future<void> cacheGiftsStrongbow({List<GiftEntity> gifts}) async {
    Box<GiftEntity> box = Hive.box<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_STRONGBOW_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(gifts);
  }

  @override
  Future<void> cacheProducts({List<ProductEntity> products}) async {
    Box<ProductEntity> box = Hive.box<ProductEntity>(AuthenticationBloc.outlet.id.toString() + PRODUCT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(products);
  }

  @override
  Future<void> cacheRivalProducts({List<RivalProductEntity> products}) async {
    Box<RivalProductEntity> box =
        Hive.box<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(products);
  }

  @override
  Future<void> cacheSetGiftCurrent({SetGiftEntity setGiftEntity}) async {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
    if (box.containsKey(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT)) {
      await box.delete(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT);
    }
    await box.put(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT, setGiftEntity);
  }

  @override
  Future<void> cacheSetGifts({List<SetGiftEntity> setGifts}) async {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    setGifts.sort((a, b) {
      return a.index.compareTo(b.index);
    });
    await box.addAll(setGifts);
    cacheChangedSet(false);
  }
  @override
  Future<void> cacheSBSetGifts({List<SetGiftEntity> setGifts}) async {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
    if (box.isNotEmpty) {
      await box.clear();
    }
    setGifts.sort((a, b) {
      return a.index.compareTo(b.index);
    });
    await box.addAll(setGifts);
    cacheChangedSet(false);
  }

  @override
  Future<void> cacheSetGiftSBCurrent({SetGiftEntity setGiftEntity}) async {
    Box<SetGiftEntity> box = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
    if (box.containsKey(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW)) {
      await box.delete(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW);
    }
    await box.put(AuthenticationBloc.outlet.id.toString() + CURRENT_SET_GIFT_STRONGBOW, setGiftEntity);
  }

  @override
  int get indexLast {
    Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
    return setGiftBox.values.toList().last.index;
  }

  @override
  bool get isSetOver {
    SetGiftEntity setCurrent = fetchSetGiftCurrent();
    if(fetchSetGift().isEmpty || setCurrent == null) return true;
    final sum = setCurrent.gifts.fold(
        0, (previousValue, element) => previousValue + element.amountCurrent);
    return setCurrent.index >= indexLast && sum == 0 ;
    }
  @override
  bool get isSetSBOver {
    SetGiftEntity setCurrent = fetchSetGiftSBCurrent();
    if(fetchSBSetGift().isEmpty || setCurrent == null) return true;
    final sum = setCurrent.gifts.fold(
        0, (previousValue, element) => previousValue + element.amountCurrent);
    return setCurrent.index >= sbIndexLast && sum == 0;
  }

  @override
  int get sbIndexLast {
    Box<SetGiftEntity> setGiftBox = Hive.box<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
    return setGiftBox.values.toList().last.index;
  }

  @override
  bool get isChangeSet{
    final isChange = sharedPrefer.getBool(AuthenticationBloc.outlet.id.toString() + IS_CHANGE_SET);
    if(isChange == null){
      return false;
    }
    return isChange;
  }


  @override
  void cacheChangedSet(bool value) {
    sharedPrefer.setBool(AuthenticationBloc.outlet.id.toString() + IS_CHANGE_SET,value);
  }

  @override
  Future<void> cacheKpi({KpiEntity kpi}) async {
    sharedPrefer.setString(AuthenticationBloc.outlet.id.toString() + KPI,jsonEncode(kpi.toJson()));
    _streamController.sink.add(kpi);
  }

  @override
  Future<void> updateKpi(List<dynamic> products) {
    final kpiStr = sharedPrefer.getString(AuthenticationBloc.outlet.id.toString() + KPI);
    if(kpiStr != null){
      final kpi = KpiEntity.fromJson(jsonDecode(kpiStr));
      final all = products.fold(0, (previousValue, element) => previousValue + element['qty']);
      final sb = products.firstWhere((element) => element['sku_id'] == 157, orElse: () => {'sku_id': 157, 'qty':0})['qty'];
      final newKpi = KpiEntity(dayOf: kpi.dayOf, sell: kpi.sell + all - sb);
      cacheKpi(kpi: newKpi);
    }
  }

  @override
  KpiEntity fetchKpi() {
    final kpiStr = sharedPrefer.getString(AuthenticationBloc.outlet.id.toString() + KPI);
    if(kpiStr != null){
      return KpiEntity.fromJson(jsonDecode(kpiStr));
    }
    return KpiEntity(dayOf: 0, sell: 0);
  }


}

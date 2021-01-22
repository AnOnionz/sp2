import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_wheel_entity.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';


abstract class ReceiveGiftLocalDataSource{
  Future<CustomerEntity> getCustomer({String name, String phone, String gender});
  Future<void> cacheCustomer({CustomerEntity customer});
  Future<HandleGiftEntity> handleGift({List<ProductEntity> products, CustomerEntity customer, SetGiftEntity setCurrent, SetGiftEntity setSBCurrent});
  Future<HandleGiftEntity> handleSBGift({StrongBowPack6 strongBowPack6, CustomerEntity customer, SetGiftEntity setCurrent});
  Future<HandleWheelEntity> handleWheel({List<GiftEntity> giftReceived, SetGiftEntity setCurrent});
  Future<HandleWheelEntity> handleStrongBowWheel({List<GiftEntity> giftReceived, SetGiftEntity setCurrent});
  Future<List<CustomerGiftEntity>> fetchCustomerGift();
  Future<void> cacheCustomerGift({CustomerGiftEntity customerGiftEntity});
  Future<void> clearCustomerGift();
  Future<void> clearAllCustomerGift();
  bool isRequireSync();
}
class ReceiveGiftLocalDataSourceImpl implements ReceiveGiftLocalDataSource {
  final DashBoardLocalDataSource local;
  final SyncLocalDataSource syncLocal;

  ReceiveGiftLocalDataSourceImpl({this.local, this.syncLocal});

  @override
  Future<HandleGiftEntity> handleGift({List<
      ProductEntity> products, CustomerEntity customer, SetGiftEntity setCurrent, SetGiftEntity setSBCurrent}) async {
    List<Gift> resultGift = <Gift>[];
    final today =  DateFormat.yMd().format(MyDateTime.day);
    final lastDay = DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(AuthenticationBloc.outlet.endPromotion*1000));
    print(today);
    print(lastDay);
    // check set current
    setCurrent = getSetGift(setCurrent);
    // set current is last set and over gift
    if (setCurrent == null) {
      if(!local.isSetSBOver && AuthenticationBloc.outlet.province == 'HN_HCM'){
        StrongBowPack6 sb = products.firstWhere((element) => element is StrongBowPack6,orElse: ()=> StrongBowPack6()..buyQty=0);
        final strongbowGift = await handleSBGift(strongBowPack6: sb, customer: customer, setCurrent: setSBCurrent);
        print("gift Strong bow will receive: ${strongbowGift.gifts}");
        print('all gift receive:  ${[...resultGift, ...strongbowGift.gifts]}');
        return HandleGiftEntity(gifts: [...resultGift, ...strongbowGift.gifts], setCurrent: setCurrent, setSBCurrent: strongbowGift.setSBCurrent);
      }
    }
    // count all gift inset

    final sum = setCurrent.gifts.fold(
        0, (previousValue, element) => previousValue + element.amountCurrent);
    print('set co $sum món');

    // get all gift available
    final gifts = local.fetchGift();
    // get gift from bought product
    LoginEntity outlet = AuthenticationBloc.outlet;
    print(outlet);// check province
    resultGift = await getGift(products, outlet);
    print("gift will receive1: $resultGift");
    // change temp gift to gift
    resultGift = resultGift.map((e) =>
        gifts.lastWhere((element) => element.giftId == e.id, orElse: () => null) ?? e)
        .toList();
    // sort gift
    print(resultGift);
    //* remove E-voucher at the last day
    if(today == lastDay){ resultGift.removeWhere((element) => element is Voucher);}

    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    // fixed length of result Gift
    int len = resultGift.length;
    resultGift = len >= customer.inTurn
        ? resultGift.sublist(0, customer.inTurn)
        : resultGift.sublist(0, len);
    print(resultGift);
    //* UseCase (HCM&HCM) Tiger & StrongBow ||(Province) Heineken & Tiger => 2 Candle*//
    //* remove one candle*//
    if (resultGift.whereType<Nen>().length >1 ) {
      int index = resultGift.lastIndexOf(resultGift.firstWhere((element) => element is Nen));
      resultGift.removeAt(index);
      resultGift.insert(index, Wheel(id: 222));
    }
    // mapping vs current SetGift
    // if set not enough then change it to Wheel
    // else update amount
    print('a $resultGift');
    resultGift = giftToWheel(resultGift, setCurrent);
    //reSort
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    // check last set
    if (setCurrent.index == local.indexLast && resultGift.length > sum) {
      print(local.indexLast);
      resultGift = resultGift.sublist(0, sum);
    }
    print("gift will receive: $resultGift");
    if(!local.isSetSBOver && AuthenticationBloc.outlet.province == 'HN_HCM'){
      StrongBowPack6 sb = products.firstWhere((element) => element is StrongBowPack6,orElse: ()=> StrongBowPack6()..buyQty=0);
      final strongbowGift = await handleSBGift(strongBowPack6: sb, customer: customer, setCurrent: setSBCurrent);
      print("gift Strong bow will receive: ${strongbowGift.gifts}");
      print('all gift receive:  ${[...resultGift, ...strongbowGift.gifts]}');
      return HandleGiftEntity(gifts: [...resultGift, ...strongbowGift.gifts], setCurrent: setCurrent, setSBCurrent: strongbowGift.setSBCurrent);
    }
    return HandleGiftEntity(gifts: resultGift, setCurrent: setCurrent);
  }
  @override
  Future<HandleGiftEntity> handleSBGift({StrongBowPack6 strongBowPack6, CustomerEntity customer, SetGiftEntity setCurrent}) async {
    List<Gift> resultGift = <Gift>[];
    print(strongBowPack6);
    // check set current
    setCurrent = getSetGiftSB(setCurrent);
    // set current is last set and over gift
    if (setCurrent == null) {
      throw(SetOver());
    }
    // count all gift inset
    final sum = setCurrent.gifts.fold(
        0, (previousValue, element) => previousValue + element.amountCurrent);
    print('Set Strongbow have $sum món');
    // get all gift available
    final gifts = local.fetchGift();
    // get gift from bought product// check province
    resultGift = await strongBowPack6.getGift();
    // change temp gift to gift
    resultGift = resultGift.map((e) =>
    gifts.lastWhere((element) => element.giftId == e.id, orElse: () => null) ?? e)
        .toList();
    // sort gift
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    // fixed length of result Gift
    int len = resultGift.length;
    resultGift = len >= customer.inSBTurn
        ? resultGift.sublist(0, customer.inSBTurn)
        : resultGift.sublist(0, len);
    // check last set
    // return all gift of last set gift
    if (setCurrent.index == local.sbIndexLast && resultGift.length > sum) {
      resultGift = resultGift.sublist(0, sum);
    }
    print("Strong bow gift will receive: $resultGift");

    return HandleStrongBowGiftEntity(gifts: resultGift, setSBCurrent: setCurrent);
  }

  Future<List<Gift>> getGift(List<ProductEntity> products,
      LoginEntity outlet) async {
    List<Gift> result = [];
    for(int i =0; i < products.length; i++){
      if(products[i] is! StrongBowPack6) {
        final giftOfProduct = await products[i].getGift(outlet: outlet);
        print(giftOfProduct);
        result.addAll(giftOfProduct);
      }
    }
    return result;
  }

  @override
  Future<HandleWheelEntity> handleWheel(
      {List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async {
    List<GiftEntity> lucky = [];
    List<GiftEntity> noLucky = [];
    // get set gift
    setCurrent = getSetGift(setCurrent);
    // set current is last set and over gift
    if (setCurrent == null) {
      throw(SetOver());
    }
    // fetch gift > 0 in set gift
    List<GiftEntity> gifts = setCurrent.gifts.where((element) => element.amountCurrent > 0).toList();
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
    print('nolucky: $noLucky');
    final today = DateFormat.yMd().format(MyDateTime.day);
    final lastDay = DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(AuthenticationBloc.outlet.endPromotion*1000));
    if(today == lastDay){lucky.removeWhere((element) => element is Voucher);}
    print(lucky);
    if (lucky.isEmpty) {
      if (noLucky.isNotEmpty) {
        lucky = noLucky;
      }
      if (noLucky.isEmpty) {
        int index = setCurrent.index;
        setCurrent = local.fetchNewSetGift(index);
        if (setCurrent == null) {
          throw(SetOver());
        }
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
    //* remove E-voucher at the last day
    print("lucky gift: $lucky");
    return HandleWheelEntity(setCurrent: setCurrent, lucky: lucky);
  }
  @override
  Future<HandleWheelEntity> handleStrongBowWheel({List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async{
    List<GiftEntity> lucky = [];
    List<GiftEntity> noLucky = [];
    // check current set is empty
    setCurrent = getSetGiftSB(setCurrent);
    // set current is last set and over gift
    if (setCurrent == null) {
      throw(SetOver());
    }
    print(setCurrent);
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
        int index = setCurrent.index;
        setCurrent = local.fetchNewSBSetGift(index);
        if (setCurrent == null) {
          throw(SetOver());
        }
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
    print("Strongbow lucky gift: $lucky");
    return HandleWheelEntity(setCurrent: setCurrent, lucky: lucky);
  }

  bool checkContain(GiftEntity gift, List<GiftEntity> giftsReceived) {
    return giftsReceived.map((e) => e.giftId).contains(gift.giftId);
  }

  @override
  Future<void> cacheCustomerGift({CustomerGiftEntity customerGiftEntity}) async {
    Box<CustomerGiftEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + CUSTOMER_GIFT_BOX);
    await box.add(customerGiftEntity);
    await syncLocal.addSync(type: 1, value: 1);
    await syncLocal.addSync(type: 2, value: 1);
    print("customer gift: ${box.values.toList()}");
  }

  @override
  Future<void> clearCustomerGift() async{
    await syncLocal.removeSync(type: 1, value: 1);
    await syncLocal.removeSync(type: 2, value: 1);
  }

  @override
  Future<List<CustomerGiftEntity>> fetchCustomerGift() async{
    Box<CustomerGiftEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + CUSTOMER_GIFT_BOX);
    return box.values.toList();
  }

  @override
  Future<void> cacheCustomer({CustomerEntity customer}) async {
    try {
      // membership
      CustomerEntity customerInDB = await getCustomer(
          name: customer.name, gender: customer.gender, phone: customer.phoneNumber);
      customerInDB.inTurn = customer.inTurn;
      customerInDB.inSBTurn = customer.inSBTurn;
      customerInDB.save();
    } on HiveError catch (_) {
      // new customer
      Box<CustomerEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + MyDateTime.today + CUSTOMER_BOX);
      box.add(customer);
    }
  }

  @override
  Future<CustomerEntity> getCustomer({String name, String phone, String gender}) async {
    Box<CustomerEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + MyDateTime.today + CUSTOMER_BOX);
    final outlet = AuthenticationBloc.outlet;
    List<CustomerEntity> customers = box.values.toList();
    if (customers.isEmpty) {
      return CustomerEntity(name: name,
          gender: gender,
          phoneNumber: phone,
          inTurn: outlet.turn, inSBTurn: 2);
    }

    return customers.firstWhere((element) => element.phoneNumber == phone, orElse:()=>CustomerEntity(name: name, phoneNumber: phone, gender: gender, inTurn: outlet.turn, inSBTurn: 2));

  }

  @override
  Future<void> clearAllCustomerGift() async {
    Box<CustomerGiftEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + CUSTOMER_GIFT_BOX);
    await box.clear();
  }

  @override
  bool isRequireSync() {
    Box<CustomerGiftEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + CUSTOMER_GIFT_BOX);
    return box.values.toList().isNotEmpty;
  }

  List<Gift> giftToWheel(List<Gift> resultGift, SetGiftEntity setCurrent){
    resultGift.forEach((gift) {
      if (gift is Nen) {
        if (setCurrent.gifts
            .firstWhere((element) => element is Nen)
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 333));
        }
      }
      if (gift is Voucher) {
        if (setCurrent.gifts
            .firstWhere((element) => element is Voucher)
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 444));
        }
      }
      if (gift is StrongBowGift) {
        if (setCurrent.gifts
            .firstWhere((element) => element is StrongBowGift)
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 555));
        }
      }
      if (gift is Pack4) {
        if (setCurrent.gifts
            .firstWhere((element) => element is Pack4)
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 666));
        }
      }
      if (gift is Pack6) {
        if (setCurrent.gifts
            .firstWhere((element) => element is Pack6)
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 777));
        }
      }
    });
    return resultGift;
  }
  SetGiftEntity getSetGift(SetGiftEntity setCurrent){
    final setGift = setCurrent.gifts
        .every((element) => element.amountCurrent == 0) ? local.fetchNewSetGift(setCurrent.index) : setCurrent;
      return setGift;
  }
  SetGiftEntity getSetGiftSB(SetGiftEntity setSBCurrent){
    final setGift = setSBCurrent.gifts
        .every((element) => element.amountCurrent == 0)
        ? local.fetchNewSBSetGift(setSBCurrent.index) : setSBCurrent;
    // set current is last set and over gift
      return setGift;
  }


}
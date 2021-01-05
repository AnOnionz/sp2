import 'package:hive/hive.dart';
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
  Future<CustomerEntity> getCustomer({String name, String phone});
  Future<void> cacheCustomer({CustomerEntity customer});
  Future<HandleGiftEntity> handleGift({List<ProductEntity> products,  CustomerEntity customer,SetGiftEntity setCurrent});
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
      ProductEntity> products, CustomerEntity customer, SetGiftEntity setCurrent}) async {
    List<Gift> resultGift = <Gift>[];
    //check set current
    print(products);
    setCurrent = setCurrent.gifts
        .where((element) => element.amountCurrent > 0)
        .toList()
        .isEmpty ? local.fetchNewSetGift(setCurrent.index + 1) : setCurrent;
    // set current is last set and over gift
    if (setCurrent == null) {
      throw(SetOver());
    }
    final sum = setCurrent.gifts.fold(
        0, (previousValue, element) => previousValue + element.amountCurrent);
    print('set co $sum món');
    // get set gift current
    final gifts = local.fetchGift();
    // get all Gift can receive
    LoginEntity outlet = AuthenticationBloc.outlet; // check province
    resultGift = await getGift(products, outlet);
    print("gift will receive1: $resultGift");
    // change temp gift to gift
    resultGift = resultGift.map((e) =>
        gifts.lastWhere((element) => element.giftId == e.id, orElse: () => null) ?? e)
        .toList();
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    print("gift will receive2: $resultGift");
    // fixed length of result Gift
    int len = resultGift.length;
    resultGift = len >= customer.inTurn
        ? resultGift.sublist(0, customer.inTurn)
        : resultGift.sublist(0, len);
    print("gift will receive3: $resultGift");
    //* UseCase (HCM&HCM) Tiger & StrongBow ||(Province) Heineken & Tiger => 2 Candle*//
    //* remove one candle*//
    if ((resultGift.where((element) => element is Nen)
      ..toList()).length > 1) {
      int index = resultGift.lastIndexOf(Nen());
      resultGift.removeAt(index);
      resultGift.insert(index, Wheel(id: 100));
    }
    print("gift will receive4: $resultGift");
    // mapping vs current SetGift
    // if set not enough then change it to Wheel
    // else update amount
    resultGift.forEach((gift) {
      if (gift is Nen) {
        if (setCurrent.gifts
            .firstWhere((element) => element is Nen)
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 50));
        }
      }
      if (gift is Voucher) {
        if (setCurrent.gifts
            .whereType<Voucher>()
            .first
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 60));
        }
      }
      if (gift is StrongBowGift) {
        if (setCurrent.gifts
            .whereType<StrongBowGift>()
            .first
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 70));
        }

      }
      if (gift is Pack4) {
        if (setCurrent.gifts
            .whereType<Pack4>()
            .first
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 90));
        }
      }
      if (gift is Pack6) {
        if (setCurrent.gifts
            .whereType<Pack6>()
            .first
            .amountCurrent == 0) {
          int index = resultGift.indexOf(gift);
          resultGift.remove(gift);
          resultGift.insert(index, Wheel(id: 80));
        }
      }
    });
    //reSort
    resultGift.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    print("gift will receive5: $resultGift");
    // check last set
    if (setCurrent.index == local.indexLast && customer.inTurn > sum) {
      resultGift = resultGift.sublist(0, sum);
    }
    print("gift will receive: $resultGift");

    return HandleGiftEntity(gifts: resultGift, setCurrent: setCurrent);
  }

  Future<List<Gift>> getGift(List<ProductEntity> products,
      LoginEntity outlet) async {
    List<Gift> result = [];
    for(int i =0; i < products.length; i++){
      final giftOfProduct = await products[i].getGift(outlet: outlet);
      result.addAll(giftOfProduct);
    }
    return result;
  }

  @override
  Future<HandleWheelEntity> handleWheel(
      {List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async {
    List<GiftEntity> lucky = [];
    List<GiftEntity> noLucky = [];
    // check current set is empty
    setCurrent = setCurrent.gifts
        .where((element) => element.amountCurrent > 0)
        .toList()
        .isEmpty ? local.fetchNewSetGift(setCurrent.index + 1) : setCurrent;
    if (setCurrent == null) {
      throw(SetOver());
    }
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
        int index = setCurrent.index + 1;
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
    print("lucky gift: $lucky");
    return HandleWheelEntity(setCurrent: setCurrent, lucky: lucky);
  }
  @override
  Future<HandleWheelEntity> handleStrongBowWheel({List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async{
    List<GiftEntity> lucky = [];
    List<GiftEntity> noLucky = [];
    // check current set is empty
    setCurrent = setCurrent.gifts
        .where((element) => element.amountCurrent > 0)
        .toList()
        .isEmpty ? local.fetchNewSBSetGift(setCurrent.index + 1) : setCurrent;
    if (setCurrent == null) {
      throw(SetOver());
    }
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
        int index = setCurrent.index + 1;
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
    print("Strongbow lucky gift: $lucky");
    return HandleWheelEntity(setCurrent: setCurrent, lucky: lucky);
  }

  bool checkContain(GiftEntity gift, List<GiftEntity> giftsReceived) {
    return giftsReceived.map((e) => e.giftId).contains(gift.giftId);
  }

  @override
  Future<void> cacheCustomerGift({CustomerGiftEntity customerGiftEntity}) async {
    Box<CustomerGiftEntity> box = Hive.box(CUSTOMER_GIFT_BOX);
    await box.clear();
    await box.add(customerGiftEntity);
    await syncLocal.addSync(type: 1, value: 1);
    await syncLocal.addSync(type: 2, value: 3);
    print("customer gift: ${box.values.toList()}");
  }

  @override
  Future<void> clearCustomerGift() async{
    await syncLocal.removeSync(type: 1, value: 1);
    await syncLocal.removeSync(type: 2, value: 3);
  }

  @override
  Future<List<CustomerGiftEntity>> fetchCustomerGift() async{
    Box<CustomerGiftEntity> box = Hive.box(CUSTOMER_GIFT_BOX);
    return box.values.toList();
  }

  @override
  Future<void> cacheCustomer({CustomerEntity customer}) async {
    try {
      // membership
      CustomerEntity customerInDB = await getCustomer(
          name: customer.name, phone: customer.phoneNumber);
      customerInDB.inTurn = customer.inTurn;
      customerInDB.save();
    } on HiveError catch (_) {
      // new customer
      Box<CustomerEntity> box = Hive.box(MyDateTime.today + CUSTOMER_BOX);
      box.add(customer);
    }
  }

  @override
  Future<CustomerEntity> getCustomer({String name, String phone}) async {
    Box<CustomerEntity> box = Hive.box(MyDateTime.today + CUSTOMER_BOX);
    final outlet = AuthenticationBloc.outlet;
    List<CustomerEntity> customers = box.values.toList();
    if (customers.isEmpty) {
      return CustomerEntity(name: name,
          phoneNumber: phone,
          inTurn: outlet.turn);
    }
    CustomerEntity customer;
    try {
      customer = customers.firstWhere((element) => element.phoneNumber == phone);
    } catch (e) {
      customer = CustomerEntity(name: name, phoneNumber: phone, inTurn: outlet.turn);
    }
    return customer;
  }

  @override
  Future<void> clearAllCustomerGift() async {
    Box<CustomerGiftEntity> box = Hive.box(CUSTOMER_GIFT_BOX);
    await box.clear();
  }

  @override
  bool isRequireSync() {
    Box<CustomerGiftEntity> box = Hive.box(CUSTOMER_GIFT_BOX);
    return box.values.toList().isNotEmpty;
  }




}
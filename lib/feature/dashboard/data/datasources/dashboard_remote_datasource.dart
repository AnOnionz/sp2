import 'package:hive/hive.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';

abstract class DashBoardRemoteDataSource {
  Future<List<ProductEntity>> fetchProduct();
  Future<List<RivalProductEntity>> fetchRivalProduct();
  Future<List<GiftEntity>> fetchGift();
  Future<List<SetGiftEntity>> fetchSetGift();
  Future<SetGiftEntity> fetchSetGiftCurrent();

}

class DashBoardRemoteDataSourceImpl implements DashBoardRemoteDataSource {
  @override
  Future<List<GiftEntity>> fetchGift() async {
    return [
      Nen(
        name: "Nến",
        giftId: 1,
        image: "",
      ),
      Voucher(
        name: "Voucher",
        giftId: 2,
        image: "",
      ),
      StrongBowGift(
        name: "StrongBow",
        giftId: 3,
        image: "",
      ),
      Pack4(
        name: "Pack4",
        giftId: 4,
        image: "",
      ),
      Pack6(
        name: "Pack6",
        giftId: 5,
        image: "",
      ),
      Magnum(
        name: "Magnum",
        giftId: 6,
        image: "",
      ),
      Alu(
        name: "Alu",
        giftId: 7,
        image: "",
      ),
    ];
  }

  @override
  Future<List<ProductEntity>> fetchProduct() async {
    return [
      HeinekenNormal(
          productId: 1,
          productName: "Heneiken",
          count: 10,
          imgUrl: "",
          price: 250000),
      Heineken0(
          productId: 2,
          productName: "Heneiken 0.0",
          count: 10,
          imgUrl: "",
          price: 250000),
      HeinekenSilver(
          productId: 3,
          productName: "Heneiken Silver",
          count: 10,
          imgUrl: "",
          price: 250000),
      TigerNormal(
          productId: 4,
          productName: "Tiger",
          count: 10,
          imgUrl: "",
          price: 250000),
      TigerCrystal(
          productId: 5,
          productName: "TigerCrystal",
          count: 10,
          imgUrl: "",
          price: 250000),
      StrongBow(
          productId: 6,
          productName: "StrongBow",
          count: 10,
          imgUrl: "",
          price: 250000),
      BiaViet(
          productId: 7,
          productName: "BiaViet",
          count: 10,
          imgUrl: "",
          price: 250000),
      Bivina(
          productId: 8,
          productName: "Bivina",
          count: 10,
          imgUrl: "",
          price: 250000),
      Larue(
          productId: 9,
          productName: "Larue",
          count: 10,
          imgUrl: "",
          price: 250000),
    ];
  }

  @override
  Future<List<SetGiftEntity>> fetchSetGift() async {
    return [
      SetGiftEntity(index: 0, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 3,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "StrongBow",
            giftId: 3,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 6,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 7,
            image: "",
            amountCurrent: 1
        ),
      ]),
//      SetGiftEntity(index: 1, gifts: [
//        Nen(
//            name: "Nến",
//            giftId: 1,
//            image: "",
//            amountCurrent: 3,
//            amountReceive: 1
//        ),
//        Voucher(
//            name: "Voucher",
//            giftId: 2,
//            image: "",
//            amountCurrent: 3,
//            amountReceive: 1
//        ),
//        StrongBowGift(
//            name: "StrongBow",
//            giftId: 3,
//            image: "",
//            amountCurrent: 1,
//            amountReceive: 1
//        ),
//        Pack4(
//            name: "Pack4",
//            giftId: 4,
//            image: "",
//            amountCurrent: 1,
//            amountReceive: 1
//        ),
//        Pack6(
//            name: "Pack6",
//            giftId: 5,
//            image: "",
//            amountCurrent: 1,
//            amountReceive: 1
//        ),
//        Magnum(
//            name: "Magnum",
//            giftId: 6,
//            image: "",
//            amountCurrent: 1,
//            amountReceive: 1
//        ),
//        Alu(
//            name: "Alu",
//            giftId: 7,
//            image: "",
//            amountCurrent: 1,
//            amountReceive: 1
//        ),
//      ]),
//      SetGiftEntity(index: 2, gifts: [
//        Nen(
//            name: "Nến",
//            giftId: 1,
//            image: "",
//            amountCurrent: 3
//        ),
//        Voucher(
//            name: "Voucher",
//            giftId: 2,
//            image: "",
//            amountCurrent: 2
//        ),
//        StrongBowGift(
//            name: "StrongBow",
//            giftId: 3,
//            image: "",
//            amountCurrent: 1
//        ),
//        Pack4(
//            name: "Pack4",
//            giftId: 4,
//            image: "",
//            amountCurrent: 1
//        ),
//        Pack6(
//            name: "Pack6",
//            giftId: 5,
//            image: "",
//            amountCurrent: 1
//        ),
//        Magnum(
//            name: "Magnum",
//            giftId: 6,
//            image: "",
//            amountCurrent: 0
//        ),
//        Alu(
//            name: "Alu",
//            giftId: 7,
//            image: "",
//            amountCurrent: 1
//        ),
//      ]),
//      SetGiftEntity(index: 3, gifts: [
//        Nen(
//            name: "Nến",
//            giftId: 1,
//            image: "",
//            amountCurrent: 3
//        ),
//        Voucher(
//            name: "Voucher",
//            giftId: 2,
//            image: "",
//            amountCurrent: 2
//        ),
//        StrongBowGift(
//            name: "StrongBow",
//            giftId: 3,
//            image: "",
//            amountCurrent: 1
//        ),
//        Pack4(
//            name: "Pack4",
//            giftId: 4,
//            image: "",
//            amountCurrent: 1
//        ),
//        Pack6(
//            name: "Pack6",
//            giftId: 5,
//            image: "",
//            amountCurrent: 1
//        ),
//        Magnum(
//            name: "Magnum",
//            giftId: 6,
//            image: "",
//            amountCurrent: 1
//        ),
//        Alu(
//            name: "Alu",
//            giftId: 7,
//            image: "",
//            amountCurrent: 0
//        ),
//      ]),
      SetGiftEntity(index: 1, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 3
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 2
        ),
        StrongBowGift(
            name: "StrongBow",
            giftId: 3,
            image: "",
            amountCurrent: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 0
        ),
        Magnum(
            name: "Magnum",
            giftId: 6,
            image: "",
            amountCurrent: 0
        ),
        Alu(
            name: "Alu",
            giftId: 7,
            image: "",
            amountCurrent: 1
        ),
      ])
    ];
  }

  @override
  Future<SetGiftEntity> fetchSetGiftCurrent() async {
    return SetGiftEntity(index: 0, gifts: [
      Nen(
        name: "Nến",
        giftId: 1,
        image: "",
        amountCurrent: 0,
        amountReceive: 1
      ),
      Voucher(
        name: "Voucher",
        giftId: 2,
        image: "",
          amountCurrent: 0,
          amountReceive: 1
      ),
      StrongBowGift(
        name: "StrongBow",
        giftId: 3,
        image: "",
          amountCurrent: 0,
          amountReceive: 1
      ),
      Pack4(
        name: "Pack4",
        giftId: 4,
        image: "",
          amountCurrent: 0,
          amountReceive: 1
      ),
      Pack6(
        name: "Pack6",
        giftId: 5,
        image: "",
          amountCurrent: 0,
          amountReceive: 1
      ),
      Magnum(
        name: "Magnum",
        giftId: 6,
        image: "",
          amountCurrent: 0,amountReceive: 1
      ),
      Alu(
        name: "Alu",
        giftId: 7,
        image: "",
          amountCurrent: 0,amountReceive: 1
      ),
    ]);
  }

  @override
  Future<List<RivalProductEntity>> fetchRivalProduct() async{
    return [
      RivalProductEntity(name: 'Sài Gòn', imgUrl: ""),
      RivalProductEntity(name: 'Hà Nội', imgUrl: ""),
      RivalProductEntity(name: 'Sư tử ', imgUrl: ""),
    ];
  }
}

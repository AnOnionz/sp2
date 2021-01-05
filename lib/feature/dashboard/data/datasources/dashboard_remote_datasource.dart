import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
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
  final CDio cDio;

  DashBoardRemoteDataSourceImpl({this.cDio});
  @override
  Future<List<GiftEntity>> fetchGift() async {

    Response _resp = await cDio.getResponse(path: 'home/gift');

    print(_resp);

    return  (_resp.data['data'] as List<dynamic>).map((e) => GiftEntity.fromJson(e)).toList();
  }

  @override
  Future<List<ProductEntity>> fetchProduct() async {

    Response _resp = await cDio.getResponse(path: 'home/product');

    print(_resp);

    return  (_resp.data['data'] as List<dynamic>).map((e) => ProductEntity.fromJson(e)).toList();
  }

  @override
  Future<List<SetGiftEntity>> fetchSetGift() async {

    //Response _resp = await cDio.getResponse(path: 'home/outlet-set-gift');

    //print(_resp);

    //return compute(SetGiftEntity.parseSetGift, _resp);

    return [
      SetGiftEntity(index: 1, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 2, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 3, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 4, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 5, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 6, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 7, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack4(
            name: "Pack4",
            giftId: 4,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Pack6(
            name: "Pack6",
            giftId: 5,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 10,
            amountReceive: 1
        ),
      ]),
    ];
  }

  @override
  Future<SetGiftEntity> fetchSetGiftCurrent() async {
    //Response _resp = await cDio.getResponse(path: 'home/gift');

    //print(_resp);

    //return SetGiftEntity.fromJson(_resp.data['data']);
   return SetGiftEntity(index: 1, gifts: [
      Nen(
          name: "Nến",
          giftId: 1,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
      Voucher(
          name: "Voucher",
          giftId: 2,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
      StrongBowGift(
          name: "Strongbow",
          giftId: 3,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
      Pack4(
          name: "Pack4",
          giftId: 4,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
      Pack6(
          name: "Pack6",
          giftId: 5,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
      Alu(
          name: "Alu",
          giftId: 6,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
      Magnum(
          name: "Magnum",
          giftId: 7,
          image: "",
          amountCurrent: 10,
          amountReceive: 1
      ),
    ]);
  }

  @override
  Future<List<RivalProductEntity>> fetchRivalProduct() async{
    Response _resp = await cDio.getResponse(path: 'home/rival-product');

    print(_resp);

    return (_resp.data['data'] as List<dynamic>).map((e) => RivalProductEntity.fromJson(e)).toList();

  }
}

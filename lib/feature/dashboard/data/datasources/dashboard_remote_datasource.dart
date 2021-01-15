import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/kpi_entity.dart';


abstract class DashBoardRemoteDataSource {
  Stream<KpiEntity> get kpiStream;
  Future<List<ProductEntity>> fetchProduct();
  Future<List<RivalProductEntity>> fetchRivalProduct();
  Future<List<GiftEntity>> fetchGift();
  Future<List<GiftEntity>> fetchGiftStrongbow();
  Future<List<SetGiftEntity>> fetchSetGift();
  Future<SetGiftEntity> fetchSetGiftCurrent();
  Future<List<SetGiftEntity>> fetchSBSetGift();
  Future<SetGiftEntity> fetchSetGiftSBCurrent();
  Future<KpiEntity> fetchKpi(KpiEntity kpi);
}

class DashBoardRemoteDataSourceImpl implements DashBoardRemoteDataSource {
  final CDio cDio;
  final StreamController<KpiEntity> _streamController = StreamController.broadcast();

  DashBoardRemoteDataSourceImpl({this.cDio});

  @override
  Stream<KpiEntity> get kpiStream => _streamController.stream;

  @override
  Future<List<GiftEntity>> fetchGift() async {

    Response _resp = await cDio.getResponse(path: 'home/gift');

    print(_resp);

   // return  (_resp.data['data'] as List<dynamic>).map((e) => GiftEntity.fromJson(e)).toList();
  return [
    Nen(
      giftId: 1,
      name: "Nến Heineken",
      image: "https://sptt21.imark.vn/image/sku/HinhQua/Nen.png",
        assetGift: "hn_nen",
        amountReceive: 1
    ),
    Voucher(
      giftId: 2,
      name: "Mã giảm giá",
      image: "https://sptt21.imark.vn/image/sku/HinhQua/Voucher.png",
        assetGift: "hn_magiamgia",
        amountReceive: 1
    ),
    StrongBowGift(
      giftId: 3,
      name: "Lon Strongbow",
      image: "https://sptt21.imark.vn/image/sku/HinhQua/Strongbow.png",
        assetGift: "hn_strongbow",
        amountReceive: 1
    ),
    Pack4(
      giftId: 4,
      name: "4 Lon Tiger Crystal",
      image: "https://sptt21.imark.vn/image/sku/HinhQua/4LonTSC.png",
        assetGift: "hn_4lon",
        amountReceive: 1
    ),
    Pack6(
      giftId: 5,
      name: "Lốc 6 HNK 0.0",
      image: "https://sptt21.imark.vn/image/sku/HinhQua/Pack6_Heineken0.0.png",
      assetGift: "hn_pack6",
      amountReceive: 1
    ),
    Magnum(
      giftId: 7,
      name: "Magnum",
      image: "https://sptt21.imark.vn/image/sku/HinhQua/Magnum.png",
        assetGift: "hn_magnum",
        amountReceive: 1
    ),
  ];
  }
  @override
  Future<List<GiftEntity>> fetchGiftStrongbow() async {

//    Response _resp = await cDio.getResponse(path: 'home/gift-strongbow');
//
//    print(_resp);
//
//    return  (_resp.data['data'] as List<dynamic>).map((e) => GiftEntity.fromJson(e)).toList();
    return [
      Glass(
        giftId: 23,
        name: "Ly Strongbow",
        image: "https://sptt21.imark.vn/image/sku/HinhQua/ly.png",
          assetGift: "st_ly",
        amountReceive: 1
      ),
      CanvasBag(
        giftId: 24,
        name: "Túi Canvas",
        image: "https://sptt21.imark.vn/image/sku/HinhQua/tui-cavas.png",
          assetGift: "st_canvas",
          amountReceive: 1
      ),
      TravelBags(
        giftId: 25,
        name: "Túi Du lịch",
        image: "https://sptt21.imark.vn/image/sku/HinhQua/tui-dulich.png",
          assetGift: "st_dulich",
          amountReceive: 1
      ),
    ];
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
            amountCurrent: 1,
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
            name: "Strongbow",
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
            amountCurrent: 1,
            amountReceive: 1
        ),
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 2, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        Voucher(
            name: "Voucher",
            giftId: 2,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        StrongBowGift(
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 3, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 2,
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 4, gifts: [
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
            name: "Strongbow",
            giftId: 3,
            image: "",
            amountCurrent: 1,
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 5, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 6, gifts: [
        Nen(
            name: "Nến",
            giftId: 1,
            image: "",
            amountCurrent: 2,
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 7, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 8, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 9, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 10, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 11, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 12, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 13, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 14, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 15, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 16, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 17, gifts: [
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
            name: "Strongbow",
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
        Alu(
            name: "Alu",
            giftId: 6,
            image: "",
            amountCurrent: 0,
            amountReceive: 1
        ),
        Magnum(
            name: "Magnum",
            giftId: 7,
            image: "",
            amountCurrent: 1,
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
          name: "Strongbow",
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
      Alu(
          name: "Alu",
          giftId: 6,
          image: "",
          amountCurrent: 0,
          amountReceive: 1
      ),
      Magnum(
          name: "Magnum",
          giftId: 7,
          image: "",
          amountCurrent: 0,
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

  @override
  Future<List<SetGiftEntity>> fetchSBSetGift() async {
    return [
      SetGiftEntity(index: 1, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 2, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 3, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 4, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 5, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 6, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 7, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 8, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 9, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 3,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 10, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 3,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 11, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 12, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 13, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 3,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 14, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 15, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 3,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 16, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
      SetGiftEntity(index: 17, gifts: [
        Glass(
            giftId: 23,
            image: "",
            amountCurrent: 2,
            amountReceive: 1
        ),
        CanvasBag(
            giftId: 24,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
        TravelBags(
            giftId: 25,
            image: "",
            amountCurrent: 1,
            amountReceive: 1
        ),
      ]),
    ];
  }

  @override
  Future<SetGiftEntity> fetchSetGiftSBCurrent() async {
    //Response _resp = await cDio.getResponse(path: 'home/gift');

    //print(_resp);

    //return SetGiftEntity.fromJson(_resp.data['data']);
    return SetGiftEntity(index: 1, gifts: [
      Glass(
          giftId: 23,
          image: "",
          amountCurrent: 2,
          amountReceive: 1
      ),
      CanvasBag(
          giftId: 24,
          image: "",
          amountCurrent: 1,
          amountReceive: 1
      ),
      TravelBags(
          giftId: 25,
          image: "",
          amountCurrent: 1,
          amountReceive: 1
      ),

    ]);
  }

  @override
  Future<KpiEntity> fetchKpi(KpiEntity kpi) {
    _streamController.sink.add(KpiEntity(dayOf: kpi.dayOf, sell: kpi.sell +1));
  }

}

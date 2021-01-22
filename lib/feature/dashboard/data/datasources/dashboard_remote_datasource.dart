import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/kpi_entity.dart';


abstract class DashBoardRemoteDataSource {
  Future<List<ProductEntity>> fetchProduct();
  Future<List<RivalProductEntity>> fetchRivalProduct();
  Future<List<GiftEntity>> fetchGift();
  Future<List<GiftEntity>> fetchGiftStrongbow();
  Future<List<SetGiftEntity>> fetchSetGift();
  Future<SetGiftEntity> fetchSetGiftCurrent();
  Future<List<SetGiftEntity>> fetchSBSetGift();
  Future<SetGiftEntity> fetchSetGiftSBCurrent();
  Future<KpiEntity> fetchKpi();
}

class DashBoardRemoteDataSourceImpl implements DashBoardRemoteDataSource {
  final CDio cDio;

  DashBoardRemoteDataSourceImpl({this.cDio});


  @override
  Future<List<GiftEntity>> fetchGift() async {

    Response _resp = await cDio.getResponse(path: 'home/gift');

    return  (_resp.data['data'] as List<dynamic>).map((e) => GiftEntity.fromJson(e)).toList();
  }
  @override
  Future<List<GiftEntity>> fetchGiftStrongbow() async {

    Response _resp = await cDio.getResponse(path: 'home/gift-strongbow');

    return  (_resp.data['data'] as List<dynamic>).map((e) => GiftEntity.fromJson(e)).toList();
  }

  @override
  Future<List<ProductEntity>> fetchProduct() async {

    Response _resp = await cDio.getResponse(path: 'home/product');

    return  (_resp.data['data'] as List<dynamic>).map((e) => ProductEntity.fromJson(e)).toList();
  }

  @override
  Future<List<SetGiftEntity>> fetchSetGift() async {

    Response _resp = await cDio.getResponse(path: 'home/outlet-set-gift');

    return (_resp.data['data'] as List<dynamic>).map((e) => SetGiftEntity.fromJson(e)).toList();

  }

  @override
  Future<SetGiftEntity> fetchSetGiftCurrent() async {

    Response _resp = await cDio.getResponse(path: 'home/outlet-set-gift-current');

    return SetGiftEntity.fromJson(_resp.data['data']);
  }

  @override
  Future<List<RivalProductEntity>> fetchRivalProduct() async{

    Response _resp = await cDio.getResponse(path: 'home/rival-product');


    return (_resp.data['data'] as List<dynamic>).map((e) => RivalProductEntity.fromJson(e)).toList();
  }

  @override
  Future<List<SetGiftEntity>> fetchSBSetGift() async {

    Response _resp = await cDio.getResponse(path: 'home/outlet-set-gift-strongbow');


    return _resp.data['data'] !=null ?  (_resp.data['data'] as List<dynamic>).map((e) => SetGiftEntity.fromJson(e)).toList() : [];

  }

  @override
  Future<SetGiftEntity> fetchSetGiftSBCurrent() async {

    Response _resp = await cDio.getResponse(path: 'home/outlet-set-gift-strongbow-current');

    return SetGiftEntity.fromJson(_resp.data['data']);
  }


  @override
  Future<KpiEntity> fetchKpi() async {
    Response _resp = await cDio.getResponse(path: '/home/kpi');

    return KpiEntity.fromJson(_resp.data['data']);
  }

}

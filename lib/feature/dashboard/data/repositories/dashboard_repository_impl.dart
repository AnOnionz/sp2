import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final NetworkInfo networkInfo;
  final DashBoardRemoteDataSource remote;
  final DashBoardLocalDataSource local;

  DashboardRepositoryImpl({this.networkInfo, this.remote, this.local});


  @override
  Future<void> saveGiftFromServer() async {
    final gifts = await remote.fetchGift();
    await local.cacheGifts(gifts: gifts);
    return Right(true);
  }

  @override
  Future<void> saveGiftStrongbowFromServer() async {
    final gifts = await remote.fetchGiftStrongbow();
    await local.cacheGiftsStrongbow(gifts: gifts);
    return Right(true);
  }

  @override
  Future<void> saveProductFromServer() async {
    final products = await remote.fetchProduct();
    await local.cacheProducts(products: products);
    return Right(true);
  }

  @override
  Future<void> saveSetGiftCurrentFromServer() async {
    final setGift = await remote.fetchSetGiftCurrent();
    await local.cacheSetGiftCurrent(setGiftEntity: setGift);
    return Right(true);
  }

  @override
  Future<void> saveSetGiftSBCurrentFromServer() async {
    final setGift = await remote.fetchSetGiftSBCurrent();
    await local.cacheSetGiftSBCurrent(setGiftEntity: setGift);
    return Right(true);
  }

  @override
  Future<void> saveSetGiftFromServer() async {
    final listSetGift = await remote.fetchSetGift();
    await local.cacheSetGifts(setGifts: listSetGift);
    return Right(true);
  }

  @override
  Future<void> saveSetGiftSBFromServer() async {
    final listSetGift = await remote.fetchSBSetGift();
    await local.cacheSBSetGifts(setGifts: listSetGift);
    return Right(true);
  }

  @override
  Future<void> saveRivalProductFromServer() async {
    final products = await remote.fetchRivalProduct();
    await local.cacheRivalProducts(products: products);
    return Right(true);
  }

  @override
  Future<void> saveKpiFromServer() async {
    final kpi = await remote.fetchKpi();
    await local.cacheKpi(kpi: kpi);
    return Right(true);
  }
}

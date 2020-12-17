import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository{
  final NetworkInfo networkInfo;
  final DashBoardRemoteDataSource remote;
  final DashBoardLocalDataSource local;

  DashboardRepositoryImpl({this.networkInfo, this.remote, this.local});

  @override
  Future<Either<Failure, bool>> saveGiftFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final gifts = await remote.fetchGift();
        await local.cacheGifts(gifts: gifts);
        return Right(true);
      }
      return Right(false);
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> saveProductFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final products = await remote.fetchProduct();
        await local.cacheProducts(products: products);
        return Right(true);
      }
      return Right(false);
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftCurrentFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final setGift = await remote.fetchSetGiftCurrent();
        print('remote: $setGift');
        await local.cacheSetGiftCurrent(setGiftEntity: setGift);
        return Right(true);
      }
      return Right(false);
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }

  }

  @override
  Future<Either<Failure, bool>> saveSetGiftFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final listSetGift = await remote.fetchSetGift();
        await local.cacheSetGifts(setGifts: listSetGift);
        return Right(true);
      }
      return Right(false);
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }

  }

  @override
  Future<Either<Failure, void>> saveRivalProductFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final products = await remote.fetchRivalProduct();
        await local.cacheRivalProducts(products: products);
        return Right(true);
      }
      return Right(false);
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }
  }


}
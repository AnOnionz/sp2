import 'package:dartz/dartz.dart';
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
    try {
      if (await networkInfo.isConnected) {
        final gifts = await remote.fetchGift();
        print("remote: $gifts");
        await local.cacheGifts(gifts: gifts);
        print("gifts: ${local.fetchGift()}");
        return Right(true);
      }
      return Left(InternetFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on InternalException catch (_) {
      return Left(InternalFailure());
    }
  }
  @override
  Future<Either<Failure, bool>> saveProductFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final products = await remote.fetchProduct();
        print("remote: $products");
        await local.cacheProducts(products: products);
        print("products: ${local.fetchProduct()}");
        return Right(true);
      }
      return Left(InternetFailure());
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on InternalException catch (_) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftCurrentFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final setGift = await remote.fetchSetGiftCurrent();
        print('remote: $setGift');
        await local.cacheSetGiftCurrent(setGiftEntity: setGift);
        print(local.fetchSetGiftCurrent());
        return Right(true);
      }
      return Left(InternetFailure());
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on InternalException catch (_) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final listSetGift = await remote.fetchSetGift();
        print("remote: $listSetGift");
        await local.cacheSetGifts(setGifts: listSetGift);
        print("list set gift: ${local.fetchSetGift()}");
        return Right(true);
      }
      return Left(InternalFailure());
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on InternalException catch (_) {
      return Left(InternalFailure());
    }

  }

  @override
  Future<Either<Failure, bool>> saveRivalProductFromServer() async {
    try{
      if(await networkInfo.isConnected){
        final products = await remote.fetchRivalProduct();
        await local.cacheRivalProducts(products: products);
        return Right(true);
      }
      return Left(InternalFailure());
    }  on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on InternalException catch (_) {
      return Left(InternalFailure());
    }
  }


}
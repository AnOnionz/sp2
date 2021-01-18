import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
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
  Future<Either<Failure, bool>> saveGiftFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final gifts = await remote.fetchGift();
        await local.cacheGifts(gifts: gifts);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveGiftStrongbowFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final gifts = await remote.fetchGiftStrongbow();
        await local.cacheGiftsStrongbow(gifts: gifts);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveProductFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remote.fetchProduct();
        await local.cacheProducts(products: products);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftCurrentFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final setGift = await remote.fetchSetGiftCurrent();
        await local.cacheSetGiftCurrent(setGiftEntity: setGift);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftSBCurrentFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final setGift = await remote.fetchSetGiftSBCurrent();
        await local.cacheSetGiftSBCurrent(setGiftEntity: setGift);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final listSetGift = await remote.fetchSetGift();
        await local.cacheSetGifts(setGifts: listSetGift);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveSetGiftSBFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final listSetGift = await remote.fetchSBSetGift();
        await local.cacheSBSetGifts(setGifts: listSetGift);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveRivalProductFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remote.fetchRivalProduct();
        await local.cacheRivalProducts(products: products);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveKpiFromServer() async {
    if (await networkInfo.isConnected) {
      try {
        final kpi = await remote.fetchKpi();
        await local.cacheKpi(kpi: kpi);
        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }
}

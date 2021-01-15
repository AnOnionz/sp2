import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/sale_price/data/datasources/sale_price_local_data_source.dart';
import 'package:sp_2021/feature/sale_price/data/datasources/sale_price_remote_data_source.dart';
import 'package:sp_2021/feature/sale_price/domain/repositories/sale_price_repository.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

class SalePriceRepositoryImpl implements SalePriceRepository {
  final NetworkInfo networkInfo;
  final SalePriceRemoteDataSource remote;
  final SalePriceLocalDataSource local;
  final DashBoardLocalDataSource dashBoardLocal;
  final SyncLocalDataSource sync;

  SalePriceRepositoryImpl(
      {this.remote,
      this.local,
      this.dashBoardLocal,
      this.sync,
      this.networkInfo});

  @override
  Future<Either<Failure, bool>> updateSalePrice(
      {List<ProductEntity> products}) async {
    final data = products
        .map((e) => {"sku_id": e.productId, "price": e.price})
        .toList();
      final dataToday = dashBoardLocal.dataToday;
      if (dataToday.checkIn != true) {
        return Left(CheckInNullFailure(
            message: 'Phải chấm công trước khi nhập giá bia bán ',));
    }
    if (await networkInfo.isConnected) {
      try {
        await remote.updateSalePrice(data: data);
        await dashBoardLocal.cacheDataToday(salePrice: data);
        return Right(true);
      } on UnAuthenticateException catch (_) {
        await local.cacheSalePrice(products);
        await dashBoardLocal.cacheDataToday(salePrice: data);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        await local.cacheSalePrice(products);
        await dashBoardLocal.cacheDataToday(salePrice: data);
        return Left(InternalFailure());
      } on InternetException catch (_) {
        await local.cacheSalePrice(products);
        await dashBoardLocal.cacheDataToday(salePrice: data);
        return Left(FailureAndCachedToLocal());
      }
    } else {
      await local.cacheSalePrice(products);
      await dashBoardLocal.cacheDataToday(salePrice: data);
      return Left(FailureAndCachedToLocal());
    }
  }

  @override
  Future<void> syncSalePrice() async {
    if(await hasSync()) {
      final data = local.fetchSalePrice();
      await remote.updateSalePrice(data: data);
      await local.clearSalePrice();
    }
  }

  @override
  Future<bool> hasSync() async {
    return local.isRequireSync();
  }
}

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
    final dataToday = await dashBoardLocal.dataToday;
    if (dataToday.checkIn != true) {
      return Left(CheckInNullFailure(
          message: "Phải chấm công trước khi nhập giá bia bán"));
    }
    if (await networkInfo.isConnected) {
      try {
        dashBoardLocal.cacheProducts(products: products);
        final data = products
            .map((e) => {"sku_id": e.productId, "price": e.price})
            .toList();
        final update = await remote.updateSalePrice(data: data);
        if (update == false) {
          local.cacheSalePrice(products);
        }
        await dashBoardLocal.cacheDataToday(highLight: false, checkOut: false, checkIn: true, inventory: false);
        return Right(update);
      } on UnAuthenticateException catch (_) {
        local.cacheSalePrice(products);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        local.cacheSalePrice(products);
        return Left(InternalFailure());
      } on InternetException catch (_) {
        await local.cacheSalePrice(products);
        return Left(NotInternetItWillCacheLocalFailure());
      }
    } else {
      await local.cacheSalePrice(products);
      return Left(NotInternetItWillCacheLocalFailure());
    }
  }

  @override
  Future<void> syncSalePrice() async {
    if(await hasSync()) {
      final data = local.fetchSalePrice();
      print(data);
      final sync = await remote.updateSalePrice(data: data);
      if (sync == true) {
        await local.clearSalePrice();
      }
    }
  }

  @override
  Future<bool> hasSync() async {
    return local.isRequireSync();
  }
}

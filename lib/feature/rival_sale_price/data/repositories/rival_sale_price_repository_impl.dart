import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/rival_sale_price/data/datasources/rival_sale_price_local_data_source.dart';
import 'package:sp_2021/feature/rival_sale_price/data/datasources/rival_sale_price_remote_data_source.dart';
import 'package:sp_2021/feature/rival_sale_price/domain/repositories/rival_sale_price_repository.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

class RivalSalePriceRepositoryImpl implements RivalSalePriceRepository {
  final NetworkInfo networkInfo;
  final RivalSalePriceRemoteDataSource remote;
  final RivalSalePriceLocalDataSource local;
  final DashBoardLocalDataSource dashBoardLocal;
  final SyncLocalDataSource sync;

  RivalSalePriceRepositoryImpl({this.networkInfo, this.remote, this.local,
      this.dashBoardLocal, this.sync});

  @override
  Future<Either<Failure, bool>> updateRivalSalePrice(
      {List<RivalProductEntity> rivals}) async {
    final data = rivals.map((e) => {"sku_id": e.id, "price": e.price}).toList();
    final dataToday = dashBoardLocal.dataToday;
    if (dataToday.checkIn != true) {
      return Left(CheckInNullFailure(
          message: "Phải chấm công trước khi nhập giá bia đối thủ"));
    }
    if (await networkInfo.isConnected) {
      try {
        await remote.updateRivalSalePrice(rivals: data);
        await dashBoardLocal.cacheDataToday(rivalSalePrice: data);
        return Right(true);
      } on UnAuthenticateException catch (_) {
        await local.cacheRivalSalePrice(rivals);
        await dashBoardLocal.cacheDataToday(rivalSalePrice: data);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        await local.cacheRivalSalePrice(rivals);
        await dashBoardLocal.cacheDataToday(rivalSalePrice: data);
        return Left(InternalFailure());
      } on InternetException catch(_){
        await local.cacheRivalSalePrice(rivals);
        await dashBoardLocal.cacheDataToday(rivalSalePrice: data);
        return Left(FailureAndCachedToLocal());
      }
    } else {
      await local.cacheRivalSalePrice(rivals);
      await dashBoardLocal.cacheDataToday(rivalSalePrice: data);
      return Left(FailureAndCachedToLocal());
    }
  }

  @override
  Future<bool> hasSync() {
    return local.isRequireSync();
  }

  @override
  Future<void> syncRivalSalePrice() async {
    if(await hasSync()) {
      final data = local.fetchRivalSalePrice();
      await remote.updateRivalSalePrice(rivals: data);
      await local.clearRivalSalePrice();

    }
  }

}

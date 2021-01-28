import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:sp_2021/feature/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/inventory/domain/repositories/inventory_repository.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final DashBoardLocalDataSource dashboardLocal;
  final InventoryLocalDataSource local;
  final InventoryRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final SyncLocalDataSource syncLocal;

  InventoryRepositoryImpl(
      {this.dashboardLocal,
      this.local,
      this.remote,
      this.networkInfo,
      this.syncLocal});
  @override
  Future<Either<Failure, bool>> saveInventoryToServer(
      {InventoryEntity inventory}) async {
    if (await networkInfo.isConnected) {
      try {
        // end inventory not found
        if(inventory.outInventory.every((element) => element['qty'] == 0)){
          await remote.updateInventory(inventory.inInventory);
          await dashboardLocal.cacheDataToday(
              inventoryEntity: inventory);
          return Right(false);
        }
        await remote.updateInventory(inventory.inInventory);
        await remote.updateEndInventory(inventory.outInventory);
        await dashboardLocal.cacheDataToday(
            inventory: true, inventoryEntity: inventory);
        return Right(true);
      } on UnAuthenticateException catch (_) {
        await local.cacheInventory(inventory);
        await dashboardLocal.cacheDataToday(
            inventoryEntity: inventory);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        await local.cacheInventory(inventory);
        await dashboardLocal.cacheDataToday(
             inventoryEntity: inventory);
        return Left(InternalFailure());
      } on InternetException catch (_) {
        await dashboardLocal.cacheDataToday(
            inventoryEntity: inventory);
        await local.cacheInventory(inventory);
        return Left(FailureAndCachedToLocal());
      }
    } else {
      await local.cacheInventory(inventory);
      await dashboardLocal.cacheDataToday(
          inventoryEntity: inventory);
      return Left(FailureAndCachedToLocal());
    }
  }

  @override
  Future<Either<Failure, bool>> syncInventory() async {
    if (await hasSync()) {
      final data = local.fetchInventory();
      print(data);
      for(InventoryEntity inv in data){
        await remote.updateInventory(inv.inInventory);
        if(inv.outInventory.any((element) => element['qty'] != 0)) {
          await remote.updateEndInventory(inv.outInventory);
          await dashboardLocal.cacheDataToday(
              inventory: true);
        }
        await local.clearInventory();
      }
      await local.clearAllInventory();
    }
    return Right(true);
  }

  @override
  Future<bool> hasSync() async {
    return local.isRequireSync();
  }
}

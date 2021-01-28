import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/highlight/domain/repositories/highlight_repository.dart';
import 'package:sp_2021/feature/inventory/domain/repositories/inventory_repository.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';
import 'package:sp_2021/feature/rival_sale_price/domain/repositories/rival_sale_price_repository.dart';
import 'package:sp_2021/feature/sale_price/domain/repositories/sale_price_repository.dart';
import 'package:sp_2021/feature/send_requirement/domain/repositories/send_requirement_repository.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';
import 'package:sp_2021/feature/sync_data/domain/repositories/sync_repository.dart';

import '../../../highlight/data/datasources/highlight_local_datasource.dart';
import '../../../inventory/data/datasources/inventory_local_data_source.dart';
import '../../../inventory/domain/entities/inventory_entity.dart';
import '../../../receive_gift/data/datasources/receive_gift_local_datasource.dart';
import '../../../receive_gift/domain/entities/customer_gift_entity.dart';
import '../../../receive_gift/domain/entities/receive_gift_entity.dart';
import '../../../rival_sale_price/data/datasources/rival_sale_price_local_data_source.dart';
import '../../../sale_price/data/datasources/sale_price_local_data_source.dart';

class SyncRepositoryImpl implements SyncRepository {
  final RivalSalePriceRepository rivalSalePriceRepository;
  final SalePriceRepository salePriceRepository;
  final HighlightRepository highlightRepository;
  final ReceiveGiftRepository receiveGiftRepository;
  final SendRequirementRepository sendRequirementRepository;
  final InventoryRepository inventoryRepository;
  final RivalSalePriceLocalDataSource rivalSalePriceLocalDataSource;
  final SalePriceLocalDataSource salePriceLocalDataSource;
  final HighLightLocalDataSource highLightLocalDataSource;
  final ReceiveGiftLocalDataSource receiveGiftLocalDataSource;
  final InventoryLocalDataSource inventoryLocalDataSource;
  final NetworkInfo networkInfo;
  final SyncLocalDataSource local;

  SyncRepositoryImpl({this.rivalSalePriceRepository, this.salePriceRepository, this.highlightRepository, this.receiveGiftRepository, this.sendRequirementRepository, this.inventoryRepository, this.rivalSalePriceLocalDataSource, this.salePriceLocalDataSource, this.highLightLocalDataSource, this.receiveGiftLocalDataSource,
  this.inventoryLocalDataSource, this.networkInfo, this.local});



  @override
  Future<Either<Failure, bool>> synchronous() async {
    if (await networkInfo.isConnected) {
      try {
        await sendRequirementRepository.syncRequirement();
        await rivalSalePriceRepository.syncRivalSalePrice();
        await salePriceRepository.syncSalePrice();
        await inventoryRepository.syncInventory();
        await highlightRepository.syncHighlight();
        await receiveGiftRepository.syncReceiveGift();
        if(! await hasDataNonSync){
          local.setSync();
        }
        return Right(true);
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        return Left(InternalFailure());
      } on InternetException catch (_) {
        return Left(InternetFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<bool> get hasDataNonSync async {
    return  await inventoryRepository.hasSync() ||
        await rivalSalePriceRepository.hasSync() ||
        await sendRequirementRepository.hasSync() ||
        await salePriceRepository.hasSync() ||
        await highlightRepository.hasSync() ||
        await receiveGiftRepository.hasSync();
  }

  @override
  Future<Map<String, dynamic>> restData() async  {
    final rival = await rivalSalePriceRepository.hasSync() ? rivalSalePriceLocalDataSource.fetchRivalSalePrice() : [];
    final price = await salePriceRepository.hasSync() ? salePriceLocalDataSource.fetchSalePrice() : [];
    final highlight = await highlightRepository.hasSync() ? highLightLocalDataSource.fetchHighlight() : null;
    final inventory = await inventoryRepository.hasSync() ? inventoryLocalDataSource.fetchInventory() : <InventoryEntity>[];
    final receive = await receiveGiftRepository.hasSync() ? receiveGiftLocalDataSource.fetchCustomerGift() : <CustomerGiftEntity>[];
    return {
      'rival': rival,
      'price': price,
      'highlight': highlight,
      'inventory': inventory,
      'receive': receive
    };
  }
}

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

class SyncRepositoryImpl implements SyncRepository {
  final RivalSalePriceRepository rivalSalePriceRepository;
  final SalePriceRepository salePriceRepository;
  final HighlightRepository highlightRepository;
  final ReceiveGiftRepository receiveGiftRepository;
  final SendRequirementRepository sendRequirementRepository;
  final InventoryRepository inventoryRepository;
  final NetworkInfo networkInfo;
  final SyncLocalDataSource local;

  SyncRepositoryImpl(
      {this.networkInfo,
      this.salePriceRepository,
      this.highlightRepository,
      this.inventoryRepository,
      this.sendRequirementRepository,
      this.rivalSalePriceRepository,
      this.receiveGiftRepository,
      this.local}
  );

  @override
  Future<Either<Failure, bool>> synchronous() async {
    if (await networkInfo.isConnected) {
      try {
        await sendRequirementRepository.syncRequirement();
        await receiveGiftRepository.syncReceiveGift();
        await rivalSalePriceRepository.syncRivalSalePrice();
        await salePriceRepository.syncSalePrice();
        await inventoryRepository.syncInventory();
        await highlightRepository.syncHighlight();
        //local.setSync();
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
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, bool>> saveInventoryToServer({@required InventoryEntity inventory});
  Future<Either<Failure, bool>> syncInventory();
  Future<bool> hasSync();


}
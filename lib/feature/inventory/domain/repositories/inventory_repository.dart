import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, bool>> updateInventory({@required List<ProductEntity> products});
}
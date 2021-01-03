import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

abstract class SalePriceRepository {
  Future<Either<Failure, bool>> updateSalePrice({@required List<ProductEntity> products});
  Future<void> syncSalePrice();
  Future<bool> hasSync();
}
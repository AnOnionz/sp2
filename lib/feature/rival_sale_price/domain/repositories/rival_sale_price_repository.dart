import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';

abstract class RivalSalePriceRepository {
  Future<Either<Failure, bool>> updateRivalSalePrice({@required List<RivalProductEntity> rivals});
  Future<void> syncRivalSalePrice();
  Future<bool> hasSync();
}
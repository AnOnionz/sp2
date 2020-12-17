import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_wheel_entity.dart';

abstract class ReceiveGiftRepository {
  Future<Either<Failure, HandleGiftEntity>> handleGift({@required List<ProductEntity> products, @required CustomerEntity customer, @required SetGiftEntity setCurrent});
  Future<Either<Failure, HandleWheelEntity>> handleWheel({@required List<GiftEntity> giftReceived, @required SetGiftEntity setCurrent});
}

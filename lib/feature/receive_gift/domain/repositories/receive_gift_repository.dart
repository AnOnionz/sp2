import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/gifts_receive.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';

abstract class ReceiveGiftRepository {
  Future<Either<Failure, GiftCanReceive>> ExportGift({@required List<ProductEntity> products, @required CustomerEntity customer});
}

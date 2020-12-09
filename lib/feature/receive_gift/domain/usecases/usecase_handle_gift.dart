import 'package:dartz/dartz.dart';
import 'package:sp_2021/app/entities/gift_entity.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/app/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/gifts_receive.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

class UseCaseHandleGift implements Usecase<GiftCanReceive, HandleGiftParams>{
  final ReceiveGiftRepository repository;

  UseCaseHandleGift(this.repository);

  @override
  Future<Either<Failure, GiftCanReceive>> call(HandleGiftParams params) async {
    return await repository.ExportGift(products: params.products, customer: params.customer);

  }
}
class HandleGiftParams extends Params{
  final List<ProductEntity> products;
  final CustomerEntity customer;

  HandleGiftParams({this.products, this.customer});
  @override
  List<Object> get props => [products, customer];
}

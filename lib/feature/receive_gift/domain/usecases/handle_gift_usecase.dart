import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

class HandleGiftUseCase implements UseCase<HandleGiftEntity, HandleGiftParams>{
  final ReceiveGiftRepository repository;

  HandleGiftUseCase({this.repository});

  @override
  Future<Either<Failure, HandleGiftEntity>> call(HandleGiftParams params) async {
    return await repository.handleGift(products: params.products, customer: params.customer, setCurrent: params.setCurrent, setSBCurrent: params.setSBCurrent);

  }
}
class HandleGiftParams extends Params{
  final List<ProductEntity> products;
  final CustomerEntity customer;
  final SetGiftEntity setCurrent;
  final SetGiftEntity setSBCurrent;

  HandleGiftParams({this.products, this.customer, this.setCurrent, this.setSBCurrent});
  @override
  List<Object> get props => [products, customer, setCurrent, this.setSBCurrent];
}

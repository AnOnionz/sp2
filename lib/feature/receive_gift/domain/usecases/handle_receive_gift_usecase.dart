import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

class HandleReceiveGiftUseCase extends UseCase<bool, HandleReceiveGiftParams>{
  final ReceiveGiftRepository repository;

  HandleReceiveGiftUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(HandleReceiveGiftParams params) async {
    return await repository.handleReceiveGift(receiveGiftEntity: params.receiveGiftEntity, setCurrent: params.setCurrent, setSBCurrent: params.setSBCurrent);
  }

}
class HandleReceiveGiftParams extends Params{
  final ReceiveGiftEntity receiveGiftEntity;
  final SetGiftEntity setCurrent;
  final SetGiftEntity setSBCurrent;

  HandleReceiveGiftParams({this.receiveGiftEntity, this.setCurrent, this.setSBCurrent});

}
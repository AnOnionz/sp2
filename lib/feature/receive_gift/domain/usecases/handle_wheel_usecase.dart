import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_wheel_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

class HandleWheelUseCase implements UseCase<HandleWheelEntity, HandleWheelParams>{
  final ReceiveGiftRepository repository;

  HandleWheelUseCase({this.repository});

  @override
  Future<Either<Failure, HandleWheelEntity>> call(HandleWheelParams params) async {
    return await repository.handleWheel(giftReceived: params.giftReceived, setCurrent: params.setCurrent);
  }

}
class HandleWheelParams extends Params{
  final List<GiftEntity> giftReceived;
  final SetGiftEntity setCurrent;

  HandleWheelParams({this.giftReceived, this.setCurrent});

  @override
  List<Object> get props => [giftReceived];
}

import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

class UseVoucherUseCase extends UseCase<VoucherEntity, String>{
  final ReceiveGiftRepository repository;

  UseVoucherUseCase({this.repository});
  @override
  Future<Either<Failure, VoucherEntity>> call(String phone) async {
    return await repository.useVoucher(phone: phone);
  }

}

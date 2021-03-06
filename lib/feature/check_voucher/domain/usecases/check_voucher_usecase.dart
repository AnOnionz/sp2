import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/check_voucher_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/repositories/check_voucher_repository.dart';

class CheckVoucherUseCase extends UseCase<CheckVoucherEntity,CheckVoucherParams>{
  final CheckVoucherRepository repository;

  CheckVoucherUseCase({this.repository});

  @override
  Future<Either<Failure, CheckVoucherEntity>> call(CheckVoucherParams params) async{
    return await repository.checkVoucher(code: params.code);
  }

}
class CheckVoucherParams extends Params{
  final String code;

  CheckVoucherParams({this.code});
}
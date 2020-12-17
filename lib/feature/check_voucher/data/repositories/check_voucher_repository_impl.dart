import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/check_voucher/data/datasources/check_voucher_remote_datasource.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/repositories/check_voucher_repository.dart';

class CheckVoucherRepositoryImpl implements CheckVoucherRepository{
  final CheckVoucherRemoteDataSource remote;

  CheckVoucherRepositoryImpl({this.remote});
  @override
  Future<Either<Failure, List<VoucherHistoryEntity>>> checkVoucher({String code}) async {
     final result = await remote.checkVoucher(code: code);
     return Right(result);
  }

}
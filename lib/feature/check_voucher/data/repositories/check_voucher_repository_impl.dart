import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/check_voucher/data/datasources/check_voucher_remote_datasource.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/check_voucher_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/repositories/check_voucher_repository.dart';

class CheckVoucherRepositoryImpl implements CheckVoucherRepository {
  final CheckVoucherRemoteDataSource remote;

  CheckVoucherRepositoryImpl({this.remote});
  @override
  Future<Either<Failure, CheckVoucherEntity>> checkVoucher(
      {String code}) async {
    try {
      final result = await remote.checkVoucher(code: code);
      return Right(result);
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on InternalException catch (_) {
      return Left(InternalFailure());
    } on InternetException catch (_) {
      return Left(InternetFailure());
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/check_voucher_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';

abstract class CheckVoucherRepository{
  Future<Either<Failure, CheckVoucherEntity>> checkVoucher({@required String code});
}


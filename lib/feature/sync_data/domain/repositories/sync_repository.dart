import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';

abstract class SyncRepository{
  Future<Either<Failure, bool>> synchronous();
}
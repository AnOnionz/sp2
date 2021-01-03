import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';

abstract class SendRequirementRepository{
  Future<Either<Failure, bool>> sendRequirement({String message});
  Future<void> syncRequirement();
  Future<bool> hasSync();
}

import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';

abstract class DashboardRepository {

  Future<Either<Failure, void>> saveProductFromServer();
  Future<Either<Failure, void>> saveRivalProductFromServer();
  Future<Either<Failure, void>> saveGiftFromServer();
  Future<Either<Failure, void>> saveGiftStrongbowFromServer();
  Future<Either<Failure, void>> saveSetGiftFromServer();
  Future<Either<Failure, void>> saveSetGiftSBFromServer();
  Future<Either<Failure, void>> saveSetGiftCurrentFromServer();
  Future<Either<Failure, void>> saveSetGiftSBCurrentFromServer();
  Future<Either<Failure, void>> saveKpiFromServer();

}


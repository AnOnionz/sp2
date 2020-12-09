import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

abstract class LoginRepository{
  Future<Either<Failure, LoginEntity>> login({@required String username, @required String password, @required String deviceId});
  Future<Either<Failure, bool>> logout();
}
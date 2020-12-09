import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/login/data/datasources/login_remote_datasource.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository{
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({this.remoteDataSource});
  @override
  Future<Either<Failure, LoginEntity>> login({@required String username, @required String password, @required String deviceId}) async {
      try{
        final loginEntity = await remoteDataSource.login(username: username, password: password, deviceId: password);
        return Right(loginEntity);
      } on ResponseException catch(error){
        return Left(ResponseFailure(message: error.message));
      }
    }
  @override
  Future<Either<Failure, bool>> logout() async{
    try{
      final logout = await remoteDataSource.logout();
      return Right(logout);
    } on ResponseException catch(error) {
      return Left(ResponseFailure(message: error.message));
    }
  }

}
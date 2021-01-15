import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/login/data/datasources/login_remote_datasource.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/domain/repositories/login_repository.dart';

import '../../../../di.dart';

class LoginRepositoryImpl implements LoginRepository{
  final LoginRemoteDataSource remoteDataSource;
  final DashBoardLocalDataSource dashBoardLocal;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({this.remoteDataSource, this.networkInfo, this.dashBoardLocal});
  @override
  Future<Either<Failure, LoginEntity>> login({@required String username, @required String password, @required String deviceId}) async {
    if (await networkInfo.isConnected) {
      try {
        final loginEntity = await remoteDataSource.login(
            username: username, password: password, deviceId: password);
        return Right(loginEntity);
      } on InternetException catch(_){
        return Left(InternetFailure());
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    }else{
      return Left(InternetFailure());
    }
    }
  @override
  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        final logout = await remoteDataSource.logout();
        return Right(logout);
      } on InternetException catch(_){
        return Left(InternetFailure());
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

}
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_status.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource dataSource;
  final DashBoardLocalDataSource dashBoardLocal;
  AttendanceRepositoryImpl({this.dataSource, this.dashBoardLocal});

  @override
  Future<Either<Failure, AttendanceStatus>> checkInOrOut(
      {String type, LocationData position, File image}) async {
    final today = await  dashBoardLocal.dataToday;
    try {
//      if(type == 'CHECK_OUT' && !today.highLight){
//        return Left(HighLightNullFailure());
//      }
      final response = await dataSource.checkInOrOut(
          type: type, position: position, image: image);

      if (type == 'CHECK_IN') {
        await dashBoardLocal.cacheDataToday(checkIn: true, checkOut: false);
      }
      if (type == 'CHECK_OUT') {
        await dashBoardLocal.cacheDataToday(checkIn: false, checkOut: true);
      }
      return Right(response);
    } on UnAuthenticateException catch (error) {
      return Left(UnAuthenticateFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on InternalException catch (_) {
      return Left(InternalFailure());
    } on InternetException catch (_) {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, AttendanceType>> checkSP() async {
    try {
      final response = await dataSource.checkSP();
      return Right(response);
    } on UnAuthenticateException catch (error) {
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

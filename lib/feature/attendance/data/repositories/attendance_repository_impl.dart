import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository{
  final AttendanceRemoteDataSource dataSource;

  AttendanceRepositoryImpl({this.dataSource});

  @override
  Future<Either<Failure, AttendanceResponse>> checkInOrOut({String type, int spId, LocationData position, File image}) async{
      try{
        final response = await dataSource.checkInOrOut(type: type, spId: spId, position: position, image: image);
        return Right(response);
      } on ResponseException catch(error){
        return Left(ResponseFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, AttendanceResponse>> checkSP({String type, String code}) async {
    try{
      final response = await dataSource.checkSP(type: type, code: code);
      return Right(response);
    }on ResponseException catch(error) {
      return Left(ResponseFailure(message: error.message));
    }
  }

}
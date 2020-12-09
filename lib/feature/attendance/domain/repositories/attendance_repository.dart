import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';

abstract class AttendanceRepository {

  Future<Either<Failure, AttendanceResponse>> checkSP({@required String type, @required String code});
  Future<Either<Failure, AttendanceResponse>> checkInOrOut({@required String type, @required int spId, @required LocationData position, @required File image });

}
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_status.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';

abstract class AttendanceRepository {

  Future<Either<Failure, AttendanceType>> checkSP();
  Future<Either<Failure, AttendanceStatus>> checkInOrOut({@required String type, @required LocationData position, @required File image });

}
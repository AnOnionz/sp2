import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:location/location.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';

class UseCaseCheckInOrOut extends UseCase<AttendanceResponse, CheckInOrOutParam> {
  final AttendanceRepository repository;

  UseCaseCheckInOrOut({this.repository});
  @override
  Future<Either<Failure, AttendanceResponse>> call(CheckInOrOutParam params) async {
    return await repository.checkInOrOut(type: params.type, spId: params.spId, position: params.position, image: params.image);
  }
}

class CheckInOrOutParam extends Params {
  final String type;
  final int spId;
  final LocationData position;
  final File image;

  CheckInOrOutParam(this.type, this.spId, this.position, this.image): super();

  @override
  List<Object> get props => [type, spId, position, image];
}

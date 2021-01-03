import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:location/location.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_status.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';

class UseCaseCheckInOrOut extends UseCase<AttendanceStatus, CheckInOrOutParam> {
  final AttendanceRepository repository;

  UseCaseCheckInOrOut({this.repository});
  @override
  Future<Either<Failure, AttendanceStatus>> call(CheckInOrOutParam params) async {
    return await repository.checkInOrOut(type: params.type, position: params.position, image: params.image);
  }
}

class CheckInOrOutParam extends Params {
  final String type;
  final LocationData position;
  final File image;

  CheckInOrOutParam(this.type, this.position, this.image): super();

  @override
  List<Object> get props => [type, position, image];
}

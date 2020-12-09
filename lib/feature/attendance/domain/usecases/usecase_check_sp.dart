import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_entity.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';

class UseCaseCheckSP extends Usecase<AttendanceResponse, CheckSPParam>{
  final AttendanceRepository repository;

  UseCaseCheckSP({this.repository});
  @override
  Future<Either<Failure, AttendanceResponse>> call(CheckSPParam params) async {
    return await repository.checkSP(type: params.type, code: params.spCode);
  }

}
class CheckSPParam extends Params{
  final String type;
  final String spCode;

  CheckSPParam({this.type, this.spCode});

  @override
  List<Object> get props => [type, spCode];

}

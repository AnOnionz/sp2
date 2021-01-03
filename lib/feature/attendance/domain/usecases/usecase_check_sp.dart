import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/domain/repositories/attendance_repository.dart';

class UseCaseCheckSP extends UseCase<AttendanceType, NoParams>{
  final AttendanceRepository repository;

  UseCaseCheckSP({this.repository});
  @override
  Future<Either<Failure, AttendanceType>> call(NoParams params) async {
    return await repository.checkSP();
  }

}

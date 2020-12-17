import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handle;
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/attendance/data/model/attendance_model.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_entity.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_inout.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_sp.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final UseCaseCheckInOrOut _useCaseCheckInOrOut;
  final UseCaseCheckSP _useCaseCheckSP;

  AttendanceBloc(this._useCaseCheckSP, this._useCaseCheckInOrOut)
      : super(AttendanceInitial());

  @override
  Stream<AttendanceState> mapEventToState(
    AttendanceEvent event,
  ) async* {
    if (event is CheckAttendance) {
      yield AttendanceLoading();
      try {
        final checkSPResponse = await _useCaseCheckSP(
            CheckSPParam(type: event.type, spCode: event.spCode));
        yield* _eitherCheckSPState(checkSPResponse);
      } catch (e, s) {
        print(e);
        print(s);
        yield AttendanceFailure(error: e);
      }
    }

    if (event is CheckInOrOut) {
      yield CheckInOrOutLoading();

      try {
        final checkInOrOutResponse = await _useCaseCheckInOrOut(CheckInOrOutParam(event.type, event.spId, event.position, event.img));

      } catch (e, s) {
        print(e);
        print(s);
        yield CheckInOrOutFailure(error: e);
      }
    }
  }

  Stream<AttendanceState> _eitherCheckSPState(
    Either<Failure, AttendanceResponse> either,
  ) async* {
    yield either.fold((failure) => AttendanceFailure(error: failure.message),
        (entity) {
      if (entity == CheckSPSuccess()) {
        return AttendanceSuccess(
            message: entity.message,
            attendanceEntity: AttendanceModel.fromJson(entity.data));
      }
      if (entity == CheckSPFailure()) {
        return AttendanceFailure(error: entity.message);
      }
      return CheckInOrOutFailure(error: "new error");
    });
  }
  Stream<AttendanceState> _eitherCheckInOrOutState(
      Either<Failure, AttendanceResponse> either,
      ) async* {
    yield either.fold((failure) => AttendanceFailure(error: failure.message),
            (entity) {
          if (entity == CheckInOutSuccess()) {
            return CheckInOrOutSuccess();
          }
          if (entity == CheckInOutFailure()) {
            return CheckInOrOutFailure(error: entity.message);
          }
          return CheckInOrOutFailure(error: "new error");
        });
  }
}

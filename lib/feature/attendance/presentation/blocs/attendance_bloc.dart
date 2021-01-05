import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_status.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_inout.dart';
import 'package:sp_2021/feature/attendance/domain/usecases/usecase_check_sp.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class CheckAttendanceBloc extends Bloc<AttendanceEvent, CheckAttendanceState> {
  final UseCaseCheckSP useCaseCheckSP;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  CheckAttendanceBloc(
      {this.useCaseCheckSP, this.dashboardBloc, this.authenticationBloc})
      : super(CheckAttendanceInitial());

  @override
  Stream<CheckAttendanceState> mapEventToState(AttendanceEvent event) async* {
    if (event is CheckAttendance) {
      final checkSPResponse = await useCaseCheckSP(NoParams());
      yield* _eitherCheckAttendanceState(checkSPResponse, dashboardBloc, authenticationBloc);
    }
  }

  @override
  void onTransition(
      Transition<AttendanceEvent, CheckAttendanceState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final UseCaseCheckInOrOut useCaseCheckInOrOut;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;

  AttendanceBloc(
  {this.useCaseCheckInOrOut, this.dashboardBloc, this.authenticationBloc}
  ) : super(AttendanceInitial());

  @override
  Stream<AttendanceState> mapEventToState(
    AttendanceEvent event,
  ) async* {
    if (event is Attendance) {
      yield AttendanceLoading();
      final checkInOrOutResponse = await useCaseCheckInOrOut(
          CheckInOrOutParam(event.type, event.position, event.img));
      yield* _eitherAttendanceState(checkInOrOutResponse, dashboardBloc, authenticationBloc);
    }
  }

  @override
  void onTransition(Transition<AttendanceEvent, AttendanceState> transition) {
    print(transition);
    super.onTransition(transition);
}
}

Stream<CheckAttendanceState> _eitherCheckAttendanceState(
    Either<Failure, AttendanceType> either,
    DashboardBloc dashboardBloc,
    AuthenticationBloc authenticationBloc) async* {
  yield either.fold((failure) {
    if (failure is UnAuthenticateFailure) {
      authenticationBloc.add(ShutDown(willPop: 1));
      return null;
    }
    if (failure is InternalFailure) {
      dashboardBloc.add(InternalServer());
      return null;
    }
    if (failure is ResponseFailure) {
      return CheckAttendanceFailure(error: failure.message);
    }
    if (failure is InternetFailure) {
      return CheckAttendanceNoInternet();
    }
    return CheckAttendanceFailure(error: failure.message);
  }, (type) => CheckAttendanceSuccess(type: type));
}

Stream<AttendanceState> _eitherAttendanceState(
    Either<Failure, AttendanceStatus> either, DashboardBloc dashboardBloc,
    AuthenticationBloc authenticationBloc) async* {
  yield either.fold((failure) {
    if(failure is HasSyncFailure){
      dashboardBloc.add(SyncRequired(message: failure.message));
      return null;
    }
  if (failure is InternalFailure) {
    dashboardBloc.add(InternalServer());
    return null;
  }
  if (failure is ResponseFailure) {
    return AttendanceFailure(error: failure.message);
  }
  if (failure is InternetFailure) {
      dashboardBloc.add(AccessInternet());
      return null;
  } if(failure is HighLightNullFailure){
    return AttendanceHighlightNullFailure(message: failure.message);

  }if(failure is InventoryNullFailure){
    return AttendanceInventoryNullFailure(message: failure.message);
  }
  return AttendanceFailure(error: failure.message);},
      (status) => AttendanceSuccess());
}

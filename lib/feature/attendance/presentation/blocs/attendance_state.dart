part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final AttendanceEntity attendanceEntity;
  final String message;

  AttendanceSuccess({this.attendanceEntity, this.message});
}

class AttendanceFailure extends AttendanceState {
  final String error;

  AttendanceFailure({this.error});
}

// CHECK IN OR OUT
class CheckInOrOutLoading extends AttendanceState {}

class CheckInOrOutSuccess extends AttendanceState {}

class CheckInOrOutFailure extends AttendanceState {
  final String error;
  final AttendanceEntity attendanceEntity;

  CheckInOrOutFailure({this.attendanceEntity, this.error});
}
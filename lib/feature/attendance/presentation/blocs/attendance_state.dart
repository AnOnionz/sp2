part of 'attendance_bloc.dart';

@immutable
class AttendanceState extends Equatable {
  @override
  List<Object> get props => [];
}
@immutable
class CheckAttendanceState extends Equatable {
  @override
  List<Object> get props => [];
}
class CheckAttendanceInitial extends CheckAttendanceState{}
class CheckAttendanceSuccess extends CheckAttendanceState{
  final AttendanceType type;

  CheckAttendanceSuccess({this.type});
}
class CheckAttendanceFailure extends CheckAttendanceState{
  final String error;

  CheckAttendanceFailure({this.error});
}
class AttendanceInitial extends AttendanceState{}
class AttendanceLoading extends AttendanceState{}
class AttendanceSuccess extends AttendanceState{}
class AttendanceFailure extends AttendanceState{
  final String error ;

  AttendanceFailure({this.error});
}
class AttendanceHighlightNullFailure extends AttendanceState{
  final String message ;

  AttendanceHighlightNullFailure({this.message});
}
class AttendanceInventoryNullFailure extends AttendanceState{
  final String message ;

  AttendanceInventoryNullFailure({this.message});
}


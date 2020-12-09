part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class CheckAttendance extends AttendanceEvent {
  final String type;
  final String spCode;

  CheckAttendance({@required this.type, @required this.spCode});
}

class CheckInOrOut extends AttendanceEvent {
  final String type;
  final int spId;
  final LocationData position;
  final File img;

  CheckInOrOut({@required this.type, @required this.spId, @required this.position, this.img});
}

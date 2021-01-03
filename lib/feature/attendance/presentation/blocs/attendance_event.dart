part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class CheckAttendance extends AttendanceEvent {

}

class Attendance extends AttendanceEvent {
  final String type;
  final LocationData position;
  final File img;

  Attendance({@required this.type, @required this.position, @required this.img});
}

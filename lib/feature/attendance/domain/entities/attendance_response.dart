import 'package:equatable/equatable.dart';

class AttendanceResponse extends Equatable{
  final bool success;
  final String message;
  final dynamic data;

  AttendanceResponse({this.success, this.message, this.data});

  @override
  List<Object> get props => [success];

}
class CheckSPSuccess extends AttendanceResponse {
 CheckSPSuccess() : super (success: true);
}
class CheckSPFailure extends AttendanceResponse {
 CheckSPFailure() : super (success: false);
}
class CheckInOutSuccess extends AttendanceResponse{
 CheckInOutSuccess(): super(success: true);
}
class CheckInOutFailure extends AttendanceResponse{
CheckInOutFailure(): super(success: false);
}

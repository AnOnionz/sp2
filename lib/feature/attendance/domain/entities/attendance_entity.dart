import 'package:equatable/equatable.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';

class AttendanceEntity extends Equatable{
  final AttendanceType type;
  final String spCode;

  AttendanceEntity({this.type, this.spCode});

  @override
  List<Object> get props => [type, spCode];
}
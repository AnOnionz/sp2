import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable{
  final int spID;
  final String spCode;
  final String fullName;


  AttendanceEntity({this.spID, this.spCode, this.fullName});

  @override
  List<Object> get props => [spID,spCode, fullName];
}
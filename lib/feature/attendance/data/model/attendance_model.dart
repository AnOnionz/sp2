import 'package:sp_2021/feature/attendance/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({int spID, String spCode, String fullName})
      : super(spID: spID, spCode: spCode, fullName: fullName);
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      spID: json['sp_id'],
      spCode: json['sp_code'],
      fullName: json['full_name'],
    );
  }
  @override
  List<Object> get props => super.props;
}

import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';

class AttendanceResponseModel extends AttendanceResponse {

  AttendanceResponseModel({bool success, String message, dynamic data}): super (success: success, message: message, data: data);

  @override
  List<Object> get props => super.props;

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }


}
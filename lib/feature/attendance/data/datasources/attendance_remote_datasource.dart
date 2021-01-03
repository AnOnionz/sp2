import 'dart:io';
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:path/path.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_status.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceType> checkSP();
  Future<AttendanceStatus> checkInOrOut({String type, LocationData position, File image});
}
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource{
  final CDio cDio;

  AttendanceRemoteDataSourceImpl({this.cDio});
  @override
  Future<AttendanceStatus> checkInOrOut({String type, String spCode, LocationData position, File image}) async{
    FormData _formData = FormData.fromMap({
      'type': type,
      'lat': position.latitude,
      'lng': position.longitude,
      'image': MultipartFile.fromFileSync(
        image.path,
        filename: basename(image.path),
      ),
    });

    Response _resp = await cDio.postResponse(path: 'home/attendance', data: _formData);

    return  AttendanceStatus.SUCCESS;

  }

  @override
  Future<AttendanceType> checkSP() async {

    Response _resp = await cDio.postResponse(path: 'home/check');

    switch (_resp.data['data']['status']) {
      case 'CHECK_IN':
        return CheckOut();
      case 'CHECK_OUT':
        return CheckIn();
      default :
        return CheckIn();
    }

    }
}
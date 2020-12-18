import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_response.dart';
import 'package:path/path.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceResponse> checkSP({@required String type,@required String code});
  Future<AttendanceResponse> checkInOrOut({String type, int spId, LocationData position, File image});
}
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource{
  final CDio cDio;

  AttendanceRemoteDataSourceImpl(this.cDio);
  @override
  Future<AttendanceResponse> checkInOrOut({String type, int spId, LocationData position, File image}) async{
    FormData _formData = FormData.fromMap({
      'type': type,
      'sp_id': spId,
      'lat': position.latitude,
      'lng': position.longitude,
      'image': MultipartFile.fromFileSync(
        image.path,
        filename: basename(image.path),
      ),
    });

    Response _resp = await cDio.client.post('home/check-in-out', data: _formData);

    print(_resp);

    if (_resp.statusCode == 200) {
      return AttendanceResponse(success: _resp.data['success'], message: _resp.data['message'], data: _resp.data['data']);
    } else {
      throw ResponseException(message: _resp.data['message']);
    }
  }

  @override
  Future<AttendanceResponse> checkSP({String type, String code}) async {
    FormData _formData = FormData.fromMap({
      'sp_code': code,
    });

    Response _resp = await cDio.client.post('home/check', data: _formData);

    print(_resp);

    if (_resp.statusCode == 200) {
      return AttendanceResponse(success: _resp.data['success'], message: _resp.data['message'], data: _resp.data['data']);
    } else {
      throw ResponseException(message: _resp.data['message']);
    }
  }

}
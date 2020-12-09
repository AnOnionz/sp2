import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/feature/login/data/model/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel> login({@required String username, @required String password, @required String deviceId});
  Future<bool> logout();

}
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource{
  final CDio cDio;

  LoginRemoteDataSourceImpl({this.cDio});
  @override
  Future<LoginModel> login({String username, String password, String deviceId}) async {
    Map<String, dynamic> _requestBody = {
      'username': username,
      'password': password,
      'device_id': deviceId,
    };

    Response _resp = await cDio.client.post('auth/login', data: _requestBody);

    print(_resp);

    if (_resp.statusCode == 200 && _resp.data['success'] == true) {
      return LoginModel.fromJson(_resp.data['data']);
    } else {
      throw ResponseException(message: _resp.data['message']);
    }
  }

  @override
  Future<bool> logout() async{
    Response _resp = await cDio.client.get('home/logout');

    print(_resp);

    if (_resp.statusCode == 200) {
      return true;
    } else {
      throw ServerException(message: _resp.data['message']);
    }
  }

}
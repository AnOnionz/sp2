import 'package:dio/dio.dart';
import 'package:sp_2021/core/error/Exception.dart';
// custom dio
class CDio {
  static const String apiBaseUrl = 'https://sptt21.imark.vn';
  static const String apiPath = 'apiv2';
  Dio client;

  CDio(){
    client = Dio(BaseOptions(
      baseUrl: '$apiBaseUrl/$apiPath/',
      connectTimeout: 6000,
      receiveTimeout: 60000,
      responseType: ResponseType.json,
      validateStatus: (status) => true,
      receiveDataWhenStatusError: true,
    ),);
  }

  Future<Response> getResponse({String path, Map<String, dynamic> data}) async {
    try {
      final response = await client.get(path, queryParameters: data);
      print('$path: $response');
      if (response.statusCode == 200) {
        return response;
      }
      if (response.statusCode == 401) {
        throw(UnAuthenticateException());
      }
      if (response.statusCode == 500) {
        throw(InternalException());
      }
      if (response.data["success"] == false) {
        throw(ResponseException(message: response.data["message"]));
      }
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        throw(InternetException());
      }
    }
  }
  Future<Response> postResponse({String path, dynamic data}) async{
      try {
        final response = await client.post(path, data: data);
        print('$path: $response');
        if (response.statusCode == 200) {
          return response;
        }
        if (response.statusCode == 401) {
          throw(UnAuthenticateException());
        }
        if (response.statusCode == 500) {
          throw(InternalException());
        }
        if (response.data["success"] == false) {
          throw(ResponseException(message: response.data["message"]));
        }
        return response;
      } on DioError catch (e) {
        if (e.type == DioErrorType.CONNECT_TIMEOUT ||
            e.type == DioErrorType.RECEIVE_TIMEOUT ) {
          throw(InternetException());
        }
      }

  }

  void setBearerAuth(String token) {
   client.options.headers.addAll({'Authorization': ' Bearer $token'});
  }

  void addInterceptor(Interceptor interceptor) {
    client.interceptors.add(interceptor);
  }

  void setValidateStatus(ValidateStatus validateStatus) {
    client.options.validateStatus = validateStatus;
  }

}

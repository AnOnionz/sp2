import 'package:dio/dio.dart';
import 'package:sp_2021/core/error/Exception.dart';
// custom dio
class CDio {

  //static String apiBaseUrl;
   static const String apiBaseUrl = 'https://sptt21.imark.vn';
  //static const String apiBaseUrl = 'http://e5728b74c888.ngrok.io';

  static const String apiPath = 'apiv2';
  Dio client;

  CDio(){
    client = Dio(BaseOptions(
      baseUrl: '$apiBaseUrl/$apiPath/',
      connectTimeout: 15000,
      receiveTimeout: 60000,
      responseType: ResponseType.json,
      validateStatus: (status) => true,
      receiveDataWhenStatusError: true,
    ),);
  }

  Future<Response> getResponse({String path, Map<String, dynamic> data}) async {
    try {
      final response = await client.get(path, queryParameters: data);
      print('GET $path: ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response;
      }
      if (response.statusCode == 401) {
        throw(UnAuthenticateException());
      }
      if (response.statusCode == 500) {
        throw(InternalException());
      }
      if (response.data["success"] == false) {
        print(1);
        throw(ResponseException(message: response.data["message"]));
      }
      else{
        throw(ResponseException(message: "Đã có lỗi xảy ra (${response.statusCode}) "));
      }
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
        print('POST $path: ${response.data}');
        if (response.statusCode == 200 && response.data['success'] == true) {
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
        else{
          throw(ResponseException(message: "Đã có lỗi xảy ra (Code: ${response.statusCode})"));
        }

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
  void setHeader(int version){
    client.options.headers.addAll({
      'VersionCodeSp': '$version'});
  }

}

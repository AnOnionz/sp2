import 'package:dio/dio.dart';
// custom dio
class CDio {
  static const String apiBaseUrl = 'https://sp.imark.vn/';
  static const String apiPath = 'api';
  final Dio client;

  CDio({this.client});

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

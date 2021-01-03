class UnAuthenticateException implements Exception{
  final String message;

  UnAuthenticateException({this.message});

  @override
  String toString() {
    return message;
  }
}
class ResponseException implements Exception{
  final String message;

  ResponseException({this.message});

}
class NTPException implements Exception{}
class NoImageException implements Exception {}
class LocalException implements Exception{}
class InternetException implements Exception{}
class InternalException implements Exception{}
class SetOver implements Exception{}
class InventoryNullException implements Exception{}
class HighlightNullException implements Exception{}

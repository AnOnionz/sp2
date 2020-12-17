class ServerException implements Exception{
  final String message;

  ServerException({this.message});

  @override
  String toString() {
    return message;
  }
}
class ResponseException implements Exception{
  final String message;

  ResponseException({this.message});

}
class LocalException implements Exception{}

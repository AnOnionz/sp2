import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';

abstract class SendRequirementRemoteDataSource{
  Future<bool> sendRequirement({String message});
}
class SendRequirementRemoteDataSourceImpl implements SendRequirementRemoteDataSource{
  final CDio cDio;

  SendRequirementRemoteDataSourceImpl({this.cDio});
  @override
  Future<bool> sendRequirement({String message}) async {
    Response _resp = await cDio.postResponse(path: 'home/notification', data: FormData.fromMap({"message": message}));
    return _resp.data['success'];
  }

}
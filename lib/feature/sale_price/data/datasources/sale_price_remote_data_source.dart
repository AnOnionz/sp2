import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';

abstract class SalePriceRemoteDataSource {
  Future<bool> updateSalePrice({List<dynamic> data});
}
class SalePriceRemoteDataSourceImpl implements SalePriceRemoteDataSource{
  final CDio cDio;

  SalePriceRemoteDataSourceImpl({this.cDio});
  @override
  Future<bool> updateSalePrice({List<dynamic> data}) async {

    Response _resp = await cDio.postResponse(path:'home/price',data: data);

    print(_resp);

    return _resp.data['success'];

  }

}
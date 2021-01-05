import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';

abstract class RivalSalePriceRemoteDataSource {
  Future<bool> updateRivalSalePrice({List<dynamic> rivals});
}
class RivalSalePriceRemoteDataSourceImpl implements RivalSalePriceRemoteDataSource{
  final CDio cDio;

  RivalSalePriceRemoteDataSourceImpl({this.cDio});
  @override
  Future<bool> updateRivalSalePrice({List<dynamic> rivals}) async {

    Response _resp = await cDio.postResponse(path: 'home/rival-price',
        data: rivals);

    print(_resp);

    return _resp.data['success'];
  }

}
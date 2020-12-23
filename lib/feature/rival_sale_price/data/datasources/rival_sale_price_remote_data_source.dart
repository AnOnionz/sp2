import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';

abstract class SalePriceRemoteDataSource {
  Future<bool> updateSalePrice({List<ProductEntity> products});
}
class SalePriceRemoteDataSourceImpl implements SalePriceRemoteDataSource{
  final CDio cDio;

  SalePriceRemoteDataSourceImpl({this.cDio});
  @override
  Future<bool> updateSalePrice({List<ProductEntity> products}) async {
    final data =  products.map((e) => {"sku_id": e.productId, "price": e.price}).toList();
    Response _resp = await cDio.client.post('home/price',
        data: data);
    print(data);
    print(_resp);
    if (_resp.statusCode == 200 && _resp.data['success'] == true) {
      return true;
    }
    if(_resp.statusCode ==401){
      throw(ServerException(message: _resp.statusMessage));
    }
    else{
      throw(ResponseException(message: _resp.data['message']));
    }
  }

}
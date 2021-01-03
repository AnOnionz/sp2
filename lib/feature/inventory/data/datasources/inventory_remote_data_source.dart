import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';

abstract class InventoryRemoteDataSource {
  Future<bool> updateInventory(List<ProductEntity> products);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final CDio cDio;

  InventoryRemoteDataSourceImpl({this.cDio});

  @override
  Future<bool> updateInventory(List<ProductEntity> products) async {
    final data =  products.map((e) => {"sku_id": e.productId, "qty": e.count}).toList();
    Response _resp = await cDio.client.post('home/oos',
        data: data);
    print(data);
    print(_resp);
    if (_resp.statusCode == 200 && _resp.data['success'] == true) {
      return true;
    }
    if(_resp.statusCode ==401){
      throw(UnAuthenticateException(message: _resp.statusMessage));
    }
    else{
      throw(ResponseException(message: _resp.data['message']));
    }
  }
}

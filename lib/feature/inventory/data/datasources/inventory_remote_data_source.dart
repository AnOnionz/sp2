import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';

abstract class InventoryRemoteDataSource {
  Future<bool> updateInventory(List<dynamic> beginInventory);
  Future<bool> updateEndInventory(List<dynamic> endInventory);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final CDio cDio;

  InventoryRemoteDataSourceImpl({this.cDio});

  @override
  Future<bool> updateInventory(List<dynamic> beginInventory) async {
    Response _resp = await cDio.postResponse(path: 'home/oos',
        data: beginInventory);
    print(_resp);

    return _resp.data['success'];
  }
  @override
  Future<bool> updateEndInventory(List<dynamic>endInventory) async {
    Response _resp = await cDio.postResponse(path: 'home/oos',
        data: endInventory);
    print(_resp);

    return _resp.data['success'];
  }
}

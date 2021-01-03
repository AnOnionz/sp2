import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

abstract class SalePriceLocalDataSource {
  bool isRequireSync();
  List<dynamic> fetchSalePrice();
  Future<void> cacheSalePrice(List<ProductEntity> products);
  Future<void> clearSalePrice();

}
class SalePriceLocalDataSourceImpl implements SalePriceLocalDataSource{
  final SyncLocalDataSource syncLocalDataSource;

  SalePriceLocalDataSourceImpl({this.syncLocalDataSource});
  @override
  Future<void> cacheSalePrice(List<ProductEntity> products) async{
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(SALE_PRICE_BOX);
    final data =  products.map((e) => {"sku_id": e.productId, "price": e.price}).toList();
    if(box.isNotEmpty){
      await clearSalePrice();
    }
    await box.add(data);
    await syncLocalDataSource.addSync(type: 1, value: 1);
  }

  @override
  Future<void> clearSalePrice() async{
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(SALE_PRICE_BOX);
    await box.clear();
    await syncLocalDataSource.removeSync(type: 1, value: 1);
  }

  @override
  List<dynamic> fetchSalePrice() {
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(SALE_PRICE_BOX);
    return box.values.toList().last;
  }

  @override
  bool isRequireSync() {
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(SALE_PRICE_BOX);
    return box.values.toList().isNotEmpty;
  }
}
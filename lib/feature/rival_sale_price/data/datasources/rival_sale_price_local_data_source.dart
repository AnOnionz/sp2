import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

abstract class RivalSalePriceLocalDataSource {
  List<dynamic> fetchRivalSalePrice();
  Future<void> cacheRivalSalePrice(List<RivalProductEntity> products);
  Future<void> clearRivalSalePrice();
  Future<bool> isRequireSync();

}
class RivalSalePriceLocalDataSourceImpl implements RivalSalePriceLocalDataSource{
  final SyncLocalDataSource syncLocalDataSource;

  RivalSalePriceLocalDataSourceImpl({this.syncLocalDataSource});
  @override
  Future<void> cacheRivalSalePrice(List<RivalProductEntity> products) async{
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(AuthenticationBloc.outlet.id.toString() + RIVAL_SALE_PRICE_BOX);
    final data = products.map((e) => {"sku_id": e.id, "price": e.price}).toList();
    if(box.isNotEmpty){
      await box.clear();
      await box.add(data);
    }
    if(box.isEmpty){
      await box.add(data);
      await syncLocalDataSource.addSync(type: 1, value: 1);
    }
  }

  @override
  Future<void> clearRivalSalePrice() async{
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(AuthenticationBloc.outlet.id.toString() + RIVAL_SALE_PRICE_BOX);
    await syncLocalDataSource.removeSync(type: 1, value: 1);
    await box.clear();

  }

  @override
  List<dynamic> fetchRivalSalePrice() {
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(AuthenticationBloc.outlet.id.toString() + RIVAL_SALE_PRICE_BOX);
    return box.values.toList().last;
  }

  @override
  Future<bool> isRequireSync() async {
    Box<List<dynamic>> box = Hive.box<List<dynamic>>(AuthenticationBloc.outlet.id.toString() + RIVAL_SALE_PRICE_BOX);
    return box.values.isNotEmpty;
  }

}
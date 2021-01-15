import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

abstract class InventoryLocalDataSource {
  Future<void> cacheInventory(InventoryEntity inventory);
  List<InventoryEntity> fetchInventory();
  Future<void> clearInventory();
  Future<void> clearAllInventory();
  bool isRequireSync();

}
class InventoryLocalDataSourceImpl implements InventoryLocalDataSource{
  final SyncLocalDataSource syncLocal;

  InventoryLocalDataSourceImpl({this.syncLocal});
  @override
  Future<void> cacheInventory(InventoryEntity inventory) async {
    Box<InventoryEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + INVENTORY_BOX);
    await box.add(inventory);
    await syncLocal.addSync(type: 1, value: 1);

  }

  @override
  Future<void> clearInventory() async {
   await syncLocal.removeSync(type: 1, value: 1);
  }
  @override
  Future<void> clearAllInventory() async {
    Box<InventoryEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + INVENTORY_BOX);
    await box.clear();
  }

  @override
  List<InventoryEntity> fetchInventory() {
    Box<InventoryEntity> box = Hive.box(AuthenticationBloc.outlet.id.toString() + INVENTORY_BOX);
    return box.values.toList();
  }

  @override
  bool isRequireSync() {
    final inventory = fetchInventory();
    return inventory.length > 0 ;
  }



}
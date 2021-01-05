import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

abstract class InventoryLocalDataSource {
  Future<void> cacheInventory(InventoryEntity inventory);
  InventoryEntity fetchInventory();
  Future<void> clearInventory();
  bool isRequireSync();

}
class InventoryLocalDataSourceImpl implements InventoryLocalDataSource{
  final SyncLocalDataSource syncLocal;

  InventoryLocalDataSourceImpl({this.syncLocal});
  @override
  Future<void> cacheInventory(InventoryEntity inventory) async {
    Box<InventoryEntity> box = Hive.box(INVENTORY_BOX);
    if(box.isNotEmpty){
     await box.clear();
     await box.add(inventory);
    }else{
      await box.add(inventory);
      await syncLocal.addSync(type: 1, value: 1);
    }
  }

  @override
  Future<void> clearInventory() async {
   Box<InventoryEntity> box = Hive.box(INVENTORY_BOX);
   await box.clear();
   await syncLocal.removeSync(type: 1, value: 1);
  }

  @override
  InventoryEntity fetchInventory() {
    Box<InventoryEntity> box = Hive.box(INVENTORY_BOX);
    if(box.isEmpty){
      return null;
    }
    return box.getAt(0);
  }

  @override
  bool isRequireSync() {
    final inventory = fetchInventory();
    if(inventory == null || inventory.outInventory.isEmpty || inventory.outInventory.every((element) => element['qty']==0)){
      return false;
    }
    return true;
  }

}
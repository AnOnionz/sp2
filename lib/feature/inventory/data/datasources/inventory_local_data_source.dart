import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';

abstract class InventoryLocalDataSoucre {
  Future<void> cacheInventory(InventoryEntity inventory){

  }
}
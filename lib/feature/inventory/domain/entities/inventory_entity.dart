import 'package:hive/hive.dart';
part 'inventory_entity.g.dart';

@HiveType(typeId: 2)
class InventoryEntity extends HiveObject{
  @HiveField(0)
  List<dynamic> inInventory;
  @HiveField(1)
  List<dynamic> outInventory;

  InventoryEntity({this.inInventory, this.outInventory});

  @override
  String toString() {
    return 'InventoryEntity{inInventory: $inInventory, outInventory: $outInventory}';
  }
}
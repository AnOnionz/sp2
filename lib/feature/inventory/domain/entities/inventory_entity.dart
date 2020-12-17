import 'package:hive/hive.dart';
part 'inventory_entity.g.dart';

@HiveType(typeId: 2)
class InventoryEntity extends HiveObject{
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  HiveList inInvetory;
  @HiveField(2)
  HiveList outInventory;

  InventoryEntity({this.date, this.inInvetory, this.outInventory});

  @override
  String toString() {
    return 'InventoryEntity{date: $date, inInvetory: $inInvetory, outInventory: $outInventory}';
  }
}
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
part 'today_data_entity.g.dart';

@HiveType(typeId: 15)
// ignore: must_be_immutable
class DataTodayEntity extends Equatable with HiveObject{
  @HiveField(0)
  bool checkIn;
  @HiveField(1)
  bool checkOut;
  @HiveField(2)
  bool inventory;
  @HiveField(3)
  bool highLight;
  @HiveField(4)
  HighlightCacheEntity highlightCached;
  @HiveField(5)
  InventoryEntity inventoryEntity;

  DataTodayEntity({this.checkIn, this.checkOut, this.inventory, this.highLight, this.inventoryEntity ,this.highlightCached});

  @override
  List<Object> get props => [checkIn, checkOut, inventory, highLight, highlightCached, inventoryEntity];

  @override
  String toString() {
    return 'DataTodayEntity{checkIn: $checkIn, checkOut: $checkOut, inventory: $inventory, highLight: $highLight, highlightCached: $highlightCached, inventoryEntity: $inventoryEntity}';
  }
}
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
part 'today_data_entity.g.dart';

@HiveType(typeId: 15)
class DataTodayEntity extends Equatable with HiveObject {
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
  @HiveField(6)
  List<dynamic> salePrice;
  @HiveField(7)
  List<dynamic> rivalSalePrice;


  DataTodayEntity(
      {this.checkIn, this.checkOut, this.inventory, this.highLight, this.inventoryEntity, this.highlightCached, this.salePrice, this.rivalSalePrice});
  @override
  List<Object> get props =>
      [
        checkIn,
        checkOut,
        inventory,
        highLight,
        highlightCached,
        inventoryEntity,
        salePrice,
        rivalSalePrice,
      ];
  factory DataTodayEntity.fromJson(Map<String, dynamic> json){
    return DataTodayEntity(
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      highLight: json['highlight'],
      inventory: json['inventory'],
      inventoryEntity: InventoryEntity.fromJson(json['inventoryEntity']),
      highlightCached: HighlightCacheEntity.fromJson(json['highlightCached']),
      salePrice: json['salePrice'],
      rivalSalePrice: json['rivalSalePrice']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "checkIn": checkIn ,
      "checkOut": checkOut,
      "highlight": highLight,
      "inventory": inventory,
      "inventoryEntity": inventoryEntity == null ? null : inventoryEntity.toJson(),
      "highlightCached": highlightCached == null ? null : highlightCached.toJson(),
      "salePrice": salePrice,
      "rivalSalePrice": rivalSalePrice,
    };
  }

  @override
  String toString() {
    return 'DataTodayEntity{checkIn: $checkIn, checkOut: $checkOut, inventory: $inventory, highLight: $highLight, highlightCached: $highlightCached, inventoryEntity: $inventoryEntity, salePrice: $salePrice, rivalSalePrice: $rivalSalePrice,}';
  }
}
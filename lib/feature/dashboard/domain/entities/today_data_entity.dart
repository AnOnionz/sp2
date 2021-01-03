import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'inventory_entity.g.dart';

@HiveType(typeId: 10)
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

  DataTodayEntity({this.checkIn, this.checkOut, this.inventory, this.highLight});

  @override
  List<Object> get props => [checkIn, checkOut, inventory, highLight];

  @override
  String toString() {
    return 'DataTodayEntity{checkIn: $checkIn, checkOut: $checkOut, inventory: $inventory, highLight: $highLight}';
  }
}
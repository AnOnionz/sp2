import 'package:hive/hive.dart';
import 'gift_entity.dart';
part 'set_gift_entity.g.dart';

@HiveType(typeId: 10)
class SetGiftEntity extends HiveObject{
  @HiveField(0)
  int index;
  @HiveField(1)
  List<GiftEntity> gifts;

  SetGiftEntity({this.index, this.gifts});

  @override
  String toString() {
    return 'SetGiftEntity{index: $index, gifts: $gifts}';
  }
}
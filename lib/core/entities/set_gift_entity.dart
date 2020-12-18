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

  SetGiftEntity fromDB( SetGiftEntity setGift){
    return SetGiftEntity(index: setGift.index, gifts: setGift.gifts.map((e) {
      switch (e.giftId){
        case 1: return Nen(giftId: e.giftId, name: e.name, image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
        case 2: return Voucher(giftId: e.giftId, name: e.name, image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
        case 3: return StrongBowGift(giftId: e.giftId, name: e.name,  image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
        case 4: return Pack4(giftId: e.giftId, name: e.name, image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
        case 5: return Pack6(giftId: e.giftId, name: e.name, image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
        case 6: return Alu(giftId: e.giftId, name: e.name,  image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
        case 7: return Magnum(giftId: e.giftId, name: e.name, image: e.image, amountCurrent: e.amountCurrent, amountReceive: 1);
      }
    }).toList());
  }

  @override
  String toString() {
    return 'SetGiftEntity{index: $index, gifts: $gifts}';
  }
}
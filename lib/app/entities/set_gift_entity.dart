import 'package:sp_2021/app/entities/gift_entity.dart';

class SetGiftEntity{

  static List<GiftEntity> giftsDefault = [Nen(amountCurrent: 4, giftId: 2), StrongBowGift(amountCurrent: 2, giftId: 3), Voucher(amountCurrent: 4, giftId: 1), Pack6(amountCurrent: 1, giftId: 4), Pack4(amountCurrent: 1, giftId: 5)];
  static List<GiftEntity> giftsCurrent = [Nen(amountCurrent: 3 , giftId: 2), StrongBowGift(amountCurrent: 3, giftId: 3), Voucher(amountCurrent: 2, giftId: 1), Pack6(amountCurrent: 2, giftId: 4), Pack4(amountCurrent: 1, giftId: 5)];

  static int get amount => giftsCurrent.fold(0, (previousValue, element) => previousValue + element.amountCurrent);

}
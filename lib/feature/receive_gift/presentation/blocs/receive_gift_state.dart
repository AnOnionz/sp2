part of 'receive_gift_bloc.dart';

@immutable
abstract class ReceiveGiftState {
  ReceiveGiftState();
}

class ReceiveGiftFormStateInitial extends ReceiveGiftState {}

class ReceiveGiftPopup extends ReceiveGiftState {
  final FormEntity form;

  ReceiveGiftPopup({this.form});
}

class ReceiveGiftHandling extends ReceiveGiftState {
  final FormEntity form;

  ReceiveGiftHandling({this.form});

}

class ReceiveGiftFailure extends ReceiveGiftState {
  final String message;

  ReceiveGiftFailure({this.message});
}

class ReceiveGifShowTurn extends ReceiveGiftState {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<File> takeProductImg;
  final List<Gift> gifts;
  final String message;

  ReceiveGifShowTurn({this.customer, this.products, this.takeProductImg, this.gifts, this.message});

}

// GiftEntity
class ReceiveGiftStateNow extends ReceiveGiftState {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<File> takeProductImg;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final int giftAt;

  ReceiveGiftStateNow({this.customer, this.products, this.takeProductImg, this.giftReceive, this.giftReceived, this.giftAt});


}

// Wheel
class ReceiveGiftStateWheel extends ReceiveGiftState {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<File> takeProductImg;
  final List<GiftEntity> giftLucky; // gift se nhan trong vong quay
  final List<Gift> giftReceive; // gift se nhan toan bo activity
  final List<GiftEntity> giftReceived; // gift da nhan
  final int giftAt;

  ReceiveGiftStateWheel({this.customer, this.products, this.takeProductImg, this.giftLucky, this.giftReceive, this.giftReceived, this.giftAt});

}

// Result
class ReceiveGiftStateResult extends ReceiveGiftState {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<GiftEntity> gifts;
  final List<File> takeProductImg;

  ReceiveGiftStateResult({this.customer, this.products, this.gifts, this.takeProductImg});
}

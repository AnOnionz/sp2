part of 'receive_gift_bloc.dart';

@immutable
abstract class ReceiveGiftEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class ReceiveGiftLoadData extends ReceiveGiftEvent {}
class CheckVoucher extends ReceiveGiftEvent {}
class ReceiveGiftSubmitForm extends ReceiveGiftEvent {
  final FormEntity form;

  ReceiveGiftSubmitForm({this.form});
}
class ReceiveGiftConfirm extends ReceiveGiftEvent {
  final FormEntity form;

  ReceiveGiftConfirm({this.form});
}
class ShowGiftWheel extends ReceiveGiftEvent {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<File> takeProductImg;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final int giftAt;
  final GiftEntity gift;

  ShowGiftWheel({this.customer, this.products, this.takeProductImg, this.giftReceive, this.giftReceived, this.giftAt, this.gift});


}
class GiftNext extends ReceiveGiftEvent {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<File> takeProductImg;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final int giftAt;

  GiftNext({this.customer, this.products, this.takeProductImg, this.giftReceive, this.giftReceived, this.giftAt});


}
class ReceiveGiftResult  extends ReceiveGiftEvent {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<GiftEntity> gifts;
  final List<File> takeProductImg;
  final List<File> takeGiftImg;
  final List<File> approveImg;

  ReceiveGiftResult({this.customer, this.products, this.gifts, this.takeProductImg, this.takeGiftImg, this.approveImg});

  @override
  String toString() {
    return 'ReceiveGiftFinal{customer: $customer, products: $products, gifts: $gifts, takeProductImg: $takeProductImg, takeGiftImg: $takeGiftImg, approveImg: $approveImg}';
  }
}
class ReceiveGiftSubmit extends ReceiveGiftEvent {

}




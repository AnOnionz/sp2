part of 'receive_gift_bloc.dart';

@immutable
abstract class ReceiveGiftEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class ReceiveGiftStart extends ReceiveGiftEvent {}
class ReceiveGiftLoadData extends ReceiveGiftEvent {}
class UseVoucher extends ReceiveGiftEvent {
  final String phone;

  UseVoucher({this.phone});
}
class ReceiveGiftSubmitForm extends ReceiveGiftEvent {
  final FormEntity form;

  ReceiveGiftSubmitForm({this.form});
}
class ReceiveGiftConfirm extends ReceiveGiftEvent {
  final FormEntity form;

  ReceiveGiftConfirm({this.form});
}
class ShowGiftWheel extends ReceiveGiftEvent {
  final FormEntity form;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final List<GiftEntity> giftSBReceived;
  final int giftAt;
  final GiftEntity gift;

  ShowGiftWheel({this.form, this.giftReceive, this.giftReceived, this.giftSBReceived, this.giftAt, this.gift,});

}
class GiftNext extends ReceiveGiftEvent {
  final FormEntity form;
  final SetGiftEntity setCurrent;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final List<GiftEntity> giftSBReceived;
  final int giftAt;

  GiftNext({this.form, this.giftReceive, this.setCurrent, this.giftReceived, this.giftSBReceived, this.giftAt,});


}
class ReceiveGiftResult extends ReceiveGiftEvent {
  final ReceiveGiftEntity receiveGiftEntity;

  ReceiveGiftResult({this.receiveGiftEntity});

}
class ReceiveGiftSubmit extends ReceiveGiftEvent {
  final ReceiveGiftEntity receiveGiftEntity;

  ReceiveGiftSubmit({this.receiveGiftEntity});

}




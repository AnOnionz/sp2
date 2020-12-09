part of 'receive_gift_bloc.dart';

@immutable
abstract class ReceiveGiftEvent {}
class CheckVoucher extends ReceiveGiftEvent {}
class SubmitForm extends ReceiveGiftEvent {
  final FormEntity form;

  SubmitForm({this.form});
}
class Confirm extends ReceiveGiftEvent {
  final FormEntity form;

  Confirm({this.form});
}
class GiftNext extends ReceiveGiftEvent {}
class ReceiveGift extends ReceiveGiftEvent {}




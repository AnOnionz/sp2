part of 'receive_gift_bloc.dart';

@immutable
abstract class ReceiveGiftState extends Equatable{
  const ReceiveGiftState();
  @override
  List<Object> get props => [];
}
//Form
class ReceiveGiftForm extends ReceiveGiftState {
  final FormEntity form;

  const ReceiveGiftForm({this.form});

}
// popup
class SubmitFinal extends ReceiveGiftState{

}
class NotEnoughTurn extends ReceiveGiftState{

}
class LackOfTurn extends ReceiveGiftState{

}

// GiftEntity
class ReceiveGiftMessage extends ReceiveGiftState {}
// Wheel
class ReceiveGiftWheel extends ReceiveGiftState {}
// Result
class ReceiveGiftResult extends ReceiveGiftState {}




part of 'check_voucher_bloc.dart';

abstract class CheckVoucherEvent extends Equatable {
  const CheckVoucherEvent();
}
class CheckVoucherStart extends CheckVoucherEvent {
  final String code;

  CheckVoucherStart({this.code});
  @override
  List<Object> get props => [code];
}

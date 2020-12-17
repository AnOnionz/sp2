part of 'check_voucher_bloc.dart';

abstract class CheckVoucherEvent extends Equatable {
  const CheckVoucherEvent();
}
class CheckVoucher extends CheckVoucherEvent {
  final String code;

  CheckVoucher({this.code});
  @override
  List<Object> get props => [code];
}

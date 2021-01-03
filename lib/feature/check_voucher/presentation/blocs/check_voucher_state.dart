part of 'check_voucher_bloc.dart';

abstract class CheckVoucherState {}
class CheckVoucherInitial extends CheckVoucherState{}
class CheckVoucherLoading extends CheckVoucherState{}
class CheckVoucherSuccess extends CheckVoucherState{
  final List<VoucherHistoryEntity> history;

  CheckVoucherSuccess({this.history});
}
class CheckVoucherFailure extends CheckVoucherState{
  final String message;

  CheckVoucherFailure({this.message});
}

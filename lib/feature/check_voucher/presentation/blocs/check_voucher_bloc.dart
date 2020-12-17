import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/usecases/check_voucher_usecase.dart';

part 'check_voucher_event.dart';
part 'check_voucher_state.dart';

class CheckVoucherBloc extends Bloc<CheckVoucherEvent, CheckVoucherState> {
  final UseCaseCheckVoucher checkVoucher;
  CheckVoucherBloc({this.checkVoucher}) : super(CheckVoucherInitial());

  @override
  Stream<CheckVoucherState> mapEventToState(
    CheckVoucherEvent event,
  ) async* {
    if(event is CheckVoucher){
      yield CheckVoucherLoading();
      final history = await checkVoucher(CheckVoucherParams(code: event.code));
      yield history.fold((l) => CheckVoucherFailure(), (r) => CheckVoucherSuccess(history: r));
    }
  }
}

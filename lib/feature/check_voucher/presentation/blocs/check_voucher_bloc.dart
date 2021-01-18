import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/usecases/check_voucher_usecase.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

part 'check_voucher_event.dart';
part 'check_voucher_state.dart';

class CheckVoucherBloc extends Bloc<CheckVoucherEvent, CheckVoucherState> {
  final CheckVoucherUseCase checkVoucher;
  final DashboardBloc dashboardBloc;
  final AuthenticationBloc authenticationBloc;
  CheckVoucherBloc(
      {this.checkVoucher, this.authenticationBloc, this.dashboardBloc})
      : super(CheckVoucherInitial());

  @override
  Stream<CheckVoucherState> mapEventToState(
    CheckVoucherEvent event,
  ) async* {
    if (event is CheckVoucherStart) {
      yield CheckVoucherLoading();
      final history = await checkVoucher(CheckVoucherParams(code: event.code));
      yield* _eitherHistoryToState(history, dashboardBloc, authenticationBloc);
    }
  }
}

Stream<CheckVoucherState> _eitherHistoryToState(
    Either<Failure, List<VoucherHistoryEntity>> either,
    DashboardBloc dashboardBloc,
    AuthenticationBloc authenticationBloc) async* {
  yield either.fold((fail) {
    if (fail is InternalFailure) {
      dashboardBloc.add(InternalServer());
      return null;
    }if (fail is ResponseFailure) {
      return CheckVoucherFailure(message: fail.message);
    }if (fail is InternetFailure) {
      dashboardBloc.add(AccessInternet());
      return null;
    }if (fail is UnAuthenticateFailure){
      authenticationBloc.add(ShutDown(willPop: 1));
      return null;
    }
    return CheckVoucherFailure(message: fail.message);
  }, (result) => CheckVoucherSuccess(history: result));
}

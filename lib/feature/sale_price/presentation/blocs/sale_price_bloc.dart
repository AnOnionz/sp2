import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/sale_price/domain/usecases/sale_price_usecase.dart';

part 'sale_price_event.dart';
part 'sale_price_state.dart';

class SalePriceBloc extends Bloc<SalePriceEvent, SalePriceState> {
  final SalePriceUseCase updateSalePrice;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  SalePriceBloc({this.authenticationBloc, this.updateSalePrice, this.dashboardBloc})
      : super(SalePriceInitial());

  @override
  Stream<SalePriceState> mapEventToState(
    SalePriceEvent event,
  ) async* {
    if (event is SalePriceUpdate) {
      yield SalePriceLoading();
      final update =
          await updateSalePrice(SalePriceParams(products: event.products));
      yield* _eitherSalePriceToState(update, authenticationBloc, dashboardBloc);
    }
  }
}

Stream<SalePriceState> _eitherSalePriceToState(
    Either<Failure, bool> either, AuthenticationBloc bloc, DashboardBloc dashboardBloc) async* {
  yield either.fold((fail) {
    if (fail is CheckInNullFailure) {
      dashboardBloc.add(RequiredCheckInOrCheckOut(message: fail.message, willPop: 2));
      return SalePriceCloseDialog();
    }
    if (fail is UnAuthenticateFailure) {
      bloc.add(ShutDown(willPop: 1));
      return SalePriceCloseDialog();
    }
    if (fail is InternalFailure) {
     dashboardBloc.add(InternalServer());
      return SalePriceCloseDialog();
    }
    if(fail is HasSyncFailure){
      dashboardBloc.add(SyncRequired(message: fail.message));
    }
    if(fail is NotInternetItWillCacheLocalFailure){
      return SalePriceCached();
    }
    return SalePriceUpdateFailure(message: fail.message);
  }, (r) => SalePriceUpdated());
}

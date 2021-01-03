import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/rival_sale_price/domain/usecases/rival_sale_price_usecase.dart';

part 'rival_sale_price_event.dart';
part 'rival_sale_price_state.dart';

class RivalSalePriceBloc
    extends Bloc<RivalSalePriceEvent, RivalSalePriceState> {
  final RivalSalePriceUseCase updateRivalSalePrice;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  RivalSalePriceBloc({this.authenticationBloc, this.updateRivalSalePrice, this.dashboardBloc})
      : super(RivalSalePriceInitial());

  @override
  Stream<RivalSalePriceState> mapEventToState(
    RivalSalePriceEvent event,
  ) async* {
    if (event is RivalSalePriceUpdate) {
      yield RivalSalePriceLoading();
      final update = await updateRivalSalePrice(
          RivalSalePriceParams(rivals: event.rivals));
      yield* _eitherSalePriceToState(update, authenticationBloc, dashboardBloc);
    }
  }
}

Stream<RivalSalePriceState> _eitherSalePriceToState(
    Either<Failure, bool> either, AuthenticationBloc bloc, DashboardBloc dashboardBloc) async* {
  yield either.fold((fail) {
    if (fail is CheckInNullFailure) {
      dashboardBloc.add(RequiredCheckInOrCheckOut(message: fail.message, willPop: 2));
      return RivalSalePriceCloseDialog();
    }
    if (fail is UnAuthenticateFailure) {
      bloc.add(ShutDown(willPop: 1));
      return RivalSalePriceCloseDialog();
    }
    if (fail is InternalFailure) {
      dashboardBloc.add(InternalServer());
      return RivalSalePriceCloseDialog();
    }
    if(fail is HasSyncFailure){
      dashboardBloc.add(SyncRequired(message: fail.message));
    }
    if(fail is NotInternetItWillCacheLocalFailure){
      return RivalSalePriceCached();
    }
    return RivalSalePriceFailure(message: fail.message);
  }, (r) => RivalSalePriceUpdated());
}

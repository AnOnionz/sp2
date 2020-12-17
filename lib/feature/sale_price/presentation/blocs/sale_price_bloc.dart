import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

part 'sale_price_event.dart';
part 'sale_price_state.dart';

class SalePriceBloc extends Bloc<SalePriceEvent, SalePriceState> {
  SalePriceBloc() : super(SalePriceInitial());

  @override
  Stream<SalePriceState> mapEventToState(
    SalePriceEvent event,
  ) async* {
    if(event is SalePriceSave){
      yield SalePriceSaving();
      await Future.delayed(Duration(seconds: 2));
      yield SalePriceSaved();

    }
  }
}

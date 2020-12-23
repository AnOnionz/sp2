import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rival_sale_price_event.dart';
part 'rival_sale_price_state.dart';

class RivalSalePriceBloc extends Bloc<RivalSalePriceEvent, RivalSalePriceState> {
  RivalSalePriceBloc() : super(RivalSalePriceInitial());

  @override
  Stream<RivalSalePriceState> mapEventToState(
    RivalSalePriceEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

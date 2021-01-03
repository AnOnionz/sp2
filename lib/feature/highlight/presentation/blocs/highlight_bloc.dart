import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'highlight_event.dart';
part 'highlight_state.dart';

class HighlightBloc extends Bloc<HighlightEvent, HighlightState> {
  HighlightBloc() : super(HighlightInitial());

  @override
  Stream<HighlightState> mapEventToState(
    HighlightEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

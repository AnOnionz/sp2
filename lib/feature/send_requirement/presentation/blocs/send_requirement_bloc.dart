import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'send_requirement_event.dart';
part 'send_requirement_state.dart';

class SendRequirementBloc extends Bloc<SendRequirementEvent, SendRequirementState> {
  SendRequirementBloc() : super(SendRequirementInitial());

  @override
  Stream<SendRequirementState> mapEventToState(
    SendRequirementEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

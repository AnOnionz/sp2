import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/send_requirement/domain/usecases/send_requirement_usecase.dart';

part 'send_requirement_event.dart';
part 'send_requirement_state.dart';

class SendRequirementBloc
    extends Bloc<SendRequirementEvent, SendRequirementState> {
  final SendRequirementUseCase sendRequirement;
  SendRequirementBloc({this.sendRequirement})
      : super(SendRequirementInitial());

  @override
  Stream<SendRequirementState> mapEventToState(
    SendRequirementEvent event,
  ) async* {
    if (event is SendRequirement) {
      yield SendRequirementLoading();
      final request =
          await sendRequirement(SendRequirementParams(message: event.message));
      yield* _eitherSendToState(request);
    }
  }
}

Stream<SendRequirementState> _eitherSendToState(
    Either<Failure, bool> either) async* {
  yield either.fold((fail) {
    if(fail is InternetFailure){
      return SendRequirementCached();
    }
    if(fail is InternalFailure){
      return SendRequirementCached();
    }
    return SendRequirementFailure(message: fail.message);
  }, (success) => SendRequirementSuccess());
}

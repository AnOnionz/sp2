import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/util/validate_highlight.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';
import 'package:sp_2021/feature/highlight/domain/repositories/highlight_repository.dart';
import 'package:sp_2021/feature/highlight/domain/usecases/highlight_usecase.dart';
import 'package:sp_2021/feature/highlight/domain/usecases/highlight_validate.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

part 'highlight_event.dart';
part 'highlight_state.dart';

class HighlightBloc extends Bloc<HighlightEvent, HighlightState> {
  final HighLightUseCase uploadHighlight;
  final HighlightValidateUseCase highlightValidate;
  final DashboardBloc dashboardBloc;
  final AuthenticationBloc authenticationBloc;
  HighlightBloc(
      {this.dashboardBloc,
      this.authenticationBloc,
      this.uploadHighlight,
      this.highlightValidate})
      : super(HighlightInitial());

  @override
  Stream<HighlightState> mapEventToState(
    HighlightEvent event,
  ) async* {
    if (event is HighlightValidateForm) {
      final validate = await highlightValidate(event.highlights);
      yield* _eitherValidateHighlights(validate, this);
    }
    if (event is HighlightUpToServer) {
      yield HighlightLoading();
      final upload = await uploadHighlight(HighlightParams(
          highlights: HighlightCacheEntity(
              outletCode: 'INIT_CODE',
              workContent: event.highlights[0].content,
              workImages: event.highlights[0].images.map((e) => e.path).toList(),
              rivalContent: event.highlights[1].content,
              rivalImages: event.highlights[1].images.map((e) => e.path).toList(),
              posmContent: event.highlights[2].content,
              posmImages: event.highlights[2].images.map((e) => e.path).toList(),
              giftContent: event.highlights[3].content,
              giftImages: event.highlights[3].images.map((e) => e.path).toList(),
          )
      ));
      yield* _eitherHighLightToState(upload, dashboardBloc, authenticationBloc);
    }
  }
}

Stream<HighlightState> _eitherHighLightToState(Either<Failure, bool> either,
    DashboardBloc dashboardBloc, AuthenticationBloc authenticationBloc) async* {
  yield either.fold((fail) {
    if (fail is CheckInNullFailure) {
      dashboardBloc.add(RequiredCheckInOrCheckOut(message: fail.message, willPop: 2));
      return HighlightCloseDialog();
    }
    if (fail is UnAuthenticateFailure) {
      authenticationBloc.add(ShutDown(willPop: 1));
      return HighlightCloseDialog();
    }
    if (fail is InternalFailure) {
      dashboardBloc.add(InternalServer());
      return HighlightCloseDialog();
    }
    if (fail is HasSyncFailure) {
      dashboardBloc.add(SyncRequired(message: fail.message));
      return HighlightCloseDialog();
    }
    if (fail is NotInternetItWillCacheLocalFailure) {
      return HighlightCached();
    }
    return HighlightFailure(message: fail.message);
  }, (success) {
    if (!success) return HighlightCached();
    return HighlightUpdated();
  });
}

Stream<HighlightState> _eitherValidateHighlights(
    Either<Failure, List<HighlightEntity>> either, HighlightBloc bloc) async* {
  yield either.fold((fail) {
    if (fail is ContentFailure) {
      return HighlightNoContent(message: fail.message);
    }
    if (fail is NoImageFailure) {
      return HighlightNoImage();
    }
    return null;
  }, (success) {
    print(success);
    bloc.add(HighlightUpToServer(highlights: success));
    return HighlightClear();
  });
}

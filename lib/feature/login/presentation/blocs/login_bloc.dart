import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/domain/usecases/usecase_login.dart';
import 'package:sp_2021/feature/login/domain/usecases/usecase_logout.dart';

import 'authentication_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UsecaseLogin login;
  final UseCaseLogout logout;
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  LoginBloc({
    @required this.login,
    @required this.logout,
    @required this.dashboardBloc,
    @required this.authenticationBloc,
  })  : assert(login != null),
        assert(logout != null),
        assert(authenticationBloc != null),
        assert(dashboardBloc != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPress) {
      yield LoginLoading();
      final loginUseCase = await login(LoginParams(
          username: event.username,
          password: event.password,
          deviceid: event.deviceId));
      yield* _eitherLoginOrErrorState(loginUseCase,);
    }
    if (event is LogoutButtonPress) {
      yield LogoutLoading();
      final logoutUseCase = await logout(NoParams());
      yield* _eitherLogoutOrErrorState(
          logoutUseCase, authenticationBloc, dashboardBloc);
    }
  }
}

Stream<LoginState> _eitherLoginOrErrorState(
  Either<Failure, LoginEntity> either,
) async* {
  yield either.fold((failure) {
    if (failure is InternalFailure) {
     return LoginInternalServer(message: failure.message);
    }
    if(failure is InternetFailure){
      return LoginNoInternet();
    }
    return LoginFailure(message: failure.message);
  },
      (user) {
        MyDateTime.timeStart();
    return LoginSuccess(user: user);
  });
}

Stream<LoginState> _eitherLogoutOrErrorState(
  Either<Failure, bool> either,
  AuthenticationBloc bloc,
  DashboardBloc dashboardBloc,
) async* {
  yield either.fold((failure) {
    if (failure is HasSyncFailure) {
      dashboardBloc.add(SyncRequired(message: failure.message));
      return LogoutCloseDialog();
    }
    if (failure is CheckOutNullFailure) {
      dashboardBloc.add(RequiredCheckInOrCheckOut(message: failure.message, willPop: 1));
      return LogoutCloseDialog();
    }
    if (failure is UnAuthenticateFailure) {
      bloc.add(ShutDown(willPop: 1));
      return LogoutCloseDialog();
    }
    if (failure is InternalFailure) {
      dashboardBloc.add(InternalServer());
      return LogoutCloseDialog();
    }
    if (failure is ResponseFailure) {
      return LogoutFailure(message: failure.message);
    }
    if (failure is InternetFailure) {
      dashboardBloc.add(AccessInternet());
      return LogoutCloseDialog();
    }
    return LogoutFailure(message: failure.message);
  }, (success) {
    return LogoutSuccess();
  });
}

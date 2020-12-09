import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
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
  LoginBloc({
    @required this.login,
    @required this.logout,
    @required this.authenticationBloc,
  })  : assert(login != null),
        assert(logout != null),
        assert(authenticationBloc != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPress) {
      yield LoginLoading();
//      final loginEntity = await login(LoginParams(
//          username: event.username,
//          password: event.password,
//          deviceid: event.deviceId));
//      yield* _eitherLoginOrErrorState(loginEntity);yield LoginSuccess(user: );
      yield LoginSuccess(user:LoginEntity(id: "ma0001", accessToken: "adadadad", address: "65A-64b Trần Bình Trọng, q5, HCM", name:"Tên outlet 1", srName: "Trần Văn A", srSDT: "012345678", time: '6h-10h', province: 'HCM'));
      //authenticationBloc.add(LoggedIn(loginEntity: LoginEntity(id: "ma0001", accessToken: "adadadad", address: "65A-64b Trần Bình Trọng, q5, HCM", name:"Tên outlet 1", srName: "Trần Văn A", srSDT: "012345678", time: '6h-10h', province: 'HCM')));
    }
    if (event is LogoutButtonPress) {
      //final isLogout = await logout(NoParams());
      // ignore: unrelated_type_equality_checks
     // if(true == isLogout) {
      //
      yield LogoutSuccess();
     authenticationBloc.add((LoggedOut()));
      //}
    }
  }

  Stream<LoginState> _eitherLoginOrErrorState(
    Either<Failure, LoginEntity> either,
  ) async* {
    yield either.fold(
        (failure) => LoginFailure(message: failure.message), (user) {
      return LoginSuccess(user: user) ;
    });
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    print(transition);
    super.onTransition(transition);
  }

}

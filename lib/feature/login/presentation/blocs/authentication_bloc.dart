import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SecureStorage storage;
  LoginEntity _loginEntity;
  LoginEntity get loginEntity => _loginEntity;
  AuthenticationBloc({@required this.storage}) : super(AuthenticationInitial());
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try{
        // user from login success
        final user = await storage.readUser<String>(key: OUTLET_IN_STORAGE);
        print('OUTLET:' + user.toString());
        if(user != null) {
          _loginEntity = user;
          Future.delayed(Duration.zero);
          yield AuthenticationAuthenticated(user: user);
        }
        else{
          yield AuthenticationUnauthenticated();
        }
        } catch (e) {
          yield AuthenticationUnauthenticated();
        }
      }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      storage.writeUser(key: OUTLET_IN_STORAGE, value: event.loginEntity).toString();
      _loginEntity = event.loginEntity;
      Future.delayed(Duration.zero);
      yield AuthenticationAuthenticated(user: event.loginEntity);
    }

    if (event is LoggedOut) {
      storage.delete(key: OUTLET_IN_STORAGE);
      yield AuthenticationUnauthenticated();
    }
    if(event is ShutDown){
      yield AuthenticationUnauthenticated();
    }
  }
  @override
  void onTransition(Transition<AuthenticationEvent, AuthenticationState> transition) {
    print(transition);
    super.onTransition(transition);
  }
  @override
  void onEvent(AuthenticationEvent event) {
    print(event);
    super.onEvent(event);
  }
  @override
  void onChange(Change<AuthenticationState> change) {
    print(change);
    super.onChange(change);
  }
}

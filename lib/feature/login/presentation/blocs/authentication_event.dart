part of 'authentication_bloc.dart';

abstract class AuthenticationEvent  extends Equatable{
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}
class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  final LoginEntity loginEntity;

  LoggedIn({@required this.loginEntity});
  @override
  List<Object> get props => [loginEntity];

  @override
  String toString() => 'LoggedIn { outlet: $loginEntity.}';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}
class ShutDown extends AuthenticationEvent{
  final int willPop;

  ShutDown({this.willPop});
  @override
  String toString() => 'ShutDown';
}

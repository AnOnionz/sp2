part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginButtonPress extends LoginEvent{
  final String username;
  final String password;
  final String deviceId;

  const LoginButtonPress({@required this.username, @required this.password, @required this.deviceId});

}
class LogoutButtonPress extends LoginEvent{

}

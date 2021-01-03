part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}
class AuthenticationInitial extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationAuthenticated extends AuthenticationState {
  final LoginEntity outlet;
  AuthenticationAuthenticated({this.outlet});
  @override
  List<Object> get props => [outlet];
}
class AuthenticationUnauthenticated extends AuthenticationState {}
class AuthenticationDuplicated extends AuthenticationState {
  final int willPop;

  AuthenticationDuplicated({this.willPop});
}


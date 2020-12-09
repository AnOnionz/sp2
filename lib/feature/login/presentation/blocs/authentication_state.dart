part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}
class AuthenticationInitial extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationAuthenticated extends AuthenticationState {
  final LoginEntity user;
  AuthenticationAuthenticated({this.user});
  @override
  List<Object> get props => [user];
}
class AuthenticationUnauthenticated extends AuthenticationState {}


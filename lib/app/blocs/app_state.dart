part of 'app_bloc.dart';

@immutable
abstract class AppState extends Equatable{
  const AppState();
   @override
  // TODO: implement props
  List<Object> get props => [];
}
class AppInitial extends AppState {}
class InternetConnected extends AppState {}
class InternetNotConnected extends AppState {}

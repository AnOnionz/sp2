part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {
}
class DashboardHasSync extends DashboardState {
  final String message;

  DashboardHasSync({this.message});
}
class DashboardInitial extends DashboardState {}
class DashboardSaving extends DashboardState {}
class DashboardSaved extends DashboardState {}
class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure({this.message});
}
class DashboardNoInternet extends DashboardState {}
class DashboardRequiredCheckInOrOut extends DashboardState {
  final String message;
  final int willPop;

  DashboardRequiredCheckInOrOut({this.message, this.willPop });
}


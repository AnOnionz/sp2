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
class DashboardRefresh extends DashboardState {}
class DashboardFailure extends DashboardState {
  final String message;
  final int willPop;

  DashboardFailure({this.message, this.willPop});
}
class DashboardNoInternet extends DashboardState {}
class DashboardNoInternetInitData extends DashboardState {}
class DashboardRequiredCheckInOrOut extends DashboardState {
  final String message;
  final int willPop;

  DashboardRequiredCheckInOrOut({this.message, this.willPop });
}
class DashboardRequiredUpdate extends DashboardState {}


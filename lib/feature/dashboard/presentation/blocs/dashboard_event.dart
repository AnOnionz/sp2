part of 'dashboard_bloc.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

class SaveServerDataToLocalData extends DashboardEvent {}
class SyncRequired extends DashboardEvent {
  final String message;

  SyncRequired({this.message});
}
class AccessInternet extends DashboardEvent {}
class InternalServer extends DashboardEvent {
  final int willPop;

  InternalServer({this.willPop});
}
class RequiredCheckInOrCheckOut extends DashboardEvent {
  final String message;
  final int willPop;

  RequiredCheckInOrCheckOut({this.message, this.willPop});
}





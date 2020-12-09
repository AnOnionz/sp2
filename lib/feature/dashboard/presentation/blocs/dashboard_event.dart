part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveServerDataToLocalData extends DashboardEvent {
  final String type;

  SaveServerDataToLocalData({this.type});
}

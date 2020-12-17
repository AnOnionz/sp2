part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState extends Equatable{
  @override
  List<Object> get props => [];
}
class DashboardInitial extends DashboardState {}
class DashboardSaving extends DashboardState {}
class DashboardSaved extends DashboardState {}
class DashboardSaveFailure extends DashboardState {}


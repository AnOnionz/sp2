part of 'sync_data_bloc.dart';

@immutable
abstract class SyncDataState {}

class SyncDataCloseDialog extends SyncDataState {

}
class SyncDataInitial extends SyncDataState {}
class SyncDataLoading extends SyncDataState {}
class SyncDataSuccess extends SyncDataState {}
class SyncDataFailure extends SyncDataState {
  final String message;

  SyncDataFailure({this.message});

}

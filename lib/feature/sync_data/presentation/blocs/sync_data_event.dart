part of 'sync_data_bloc.dart';

@immutable
abstract class SyncDataEvent {
  const SyncDataEvent();
}
class SyncStart extends SyncDataEvent{
}

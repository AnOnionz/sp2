
import 'dart:async';

import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/sync_data/domain/entities/sync_entity.dart';

abstract class SyncLocalDataSource{
  Stream<int> get syncStream;
  SyncEntity getSync();
  void setSync();
  Future<void> addSync({int type, int value});
  Future<void> removeSync({int type, int value});
}
class SyncLocalDataSourceImpl implements SyncLocalDataSource{
  // ignore: close_sinks
  StreamController<int> _streamController = StreamController<int>.broadcast();

  @override
  SyncEntity getSync() {
    Box<SyncEntity> box = Hive.box<SyncEntity>(AuthenticationBloc.outlet.id.toString() + SYNC_BOX);
    final sync = box.get(AuthenticationBloc.outlet.id.toString() + SYNC_DATA_IN_STORAGE);
    if(sync == null){
      final newSync = SyncEntity(imageNonSynchronized: 0, imageSynchronized: 0, nonSynchronized: 0, synchronized: 0);
      box.put(AuthenticationBloc.outlet.id.toString() + SYNC_DATA_IN_STORAGE, newSync);
      return newSync;
    }
    return sync;
  }

  @override
  Future<void> addSync({int type, int value}) async {
    final sync = getSync();
    switch(type){
      case 1: sync.nonSynchronized += value;
      break;
      case 2: sync.imageNonSynchronized += value;
      break;
    }
   await sync.save();
    _streamController.sink.add(sync.imageNonSynchronized + sync.nonSynchronized);
  }

  @override
  Future<void> removeSync({int type, int value}) async {
    final sync = getSync();
    switch(type){
      case 1: sync.nonSynchronized -= value;
      sync.synchronized += value;
      break;
      case 2: sync.imageNonSynchronized -= value;
      sync.imageSynchronized += value;
      break;
    }
   await sync.save();
    _streamController.sink.add(sync.imageNonSynchronized + sync.nonSynchronized);
  }

  @override
  void setSync() async {
    Box<SyncEntity> box = Hive.box<SyncEntity>(AuthenticationBloc.outlet.id.toString() + SYNC_BOX);
    final sync = box.get(AuthenticationBloc.outlet.id.toString() + SYNC_DATA_IN_STORAGE);
    final cleanSync = SyncEntity(synchronized: sync.synchronized + sync.nonSynchronized,imageSynchronized: sync.imageSynchronized + sync.imageNonSynchronized, nonSynchronized: 0, imageNonSynchronized: 0);
    await box.put(AuthenticationBloc.outlet.id.toString() + SYNC_DATA_IN_STORAGE, cleanSync);

  }

  @override
  Stream<int> get syncStream => _streamController.stream;


}
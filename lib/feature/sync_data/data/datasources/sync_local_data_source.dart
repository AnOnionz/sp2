
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/sync_data/domain/entities/sync_entity.dart';

abstract class SyncLocalDataSource{
  bool get hasDataNonSync;
  SyncEntity getSync();
  Future<void> addSync({int type, int value});
  Future<void> removeSync({int type, int value});
}
class SyncLocalDataSourceImpl implements SyncLocalDataSource{

  @override
  SyncEntity getSync() {
    Box<SyncEntity> box = Hive.box<SyncEntity>(SYNC_BOX);
    final sync = box.get(SYNC_DATA_IN_STORAGE);
    if(sync == null){
      final newSync = SyncEntity(imageNonSynchronized: 0, imageSynchronized: 0, nonSynchronized: 0, synchronized: 0);
      box.put(SYNC_DATA_IN_STORAGE, newSync);
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
  }

  @override
  bool get hasDataNonSync {
    Box<List<dynamic>> salePriceBox = Hive.box(SALE_PRICE_BOX);
    return salePriceBox.isNotEmpty;
  }

}
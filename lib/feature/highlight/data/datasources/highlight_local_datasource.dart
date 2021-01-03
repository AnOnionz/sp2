import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

abstract class HighLightLocalDataSource {
  Future<void> cacheHighlight(HighlightCacheEntity highlights);
  HighlightCacheEntity fetchHighlight();
  Future<void> clearHighlight();
  bool isRequireSync();
}
class HighlightLocalDataSourceImpl implements HighLightLocalDataSource {
  final SyncLocalDataSource syncLocal;

  HighlightLocalDataSourceImpl({this.syncLocal});
  @override
  Future<void> cacheHighlight(HighlightCacheEntity highlight) async{
    Box<HighlightCacheEntity> box = Hive.box(HIGHLIGHT_BOX);
    await box.clear();
    await box.add(highlight);
    await syncLocal.addSync(type: 1, value: 1);
    await syncLocal.addSync(type: 2, value: 4);
  }

  @override
  HighlightCacheEntity fetchHighlight() {
    Box<HighlightCacheEntity> box = Hive.box(HIGHLIGHT_BOX);
    return box.values.toList()?.last;
  }

  @override
  Future<void> clearHighlight() async {
    Box<HighlightCacheEntity> box = Hive.box(HIGHLIGHT_BOX);
    await box.clear();
    await syncLocal.removeSync(type: 1, value: 1);
    await syncLocal.removeSync(type: 2, value: 4);
  }

  @override
  bool isRequireSync() {
    Box<HighlightCacheEntity> box = Hive.box(HIGHLIGHT_BOX);
    return box.values.toList().isNotEmpty;
  }
}
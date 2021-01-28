
import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';

abstract class HighlightRemoteDataSource{
  Future<bool> uploadToServer(HighlightCacheEntity highlights);
}
class HighlightRemoteDataSourceImpl implements HighlightRemoteDataSource{
  final CDio cDio;

  HighlightRemoteDataSourceImpl({this.cDio});

  @override
  Future<bool> uploadToServer(HighlightCacheEntity highlights) async {
    print(highlights);
    print(highlights.toJson());
    final _resp = await cDio.postResponse(path: 'home/highlight', data: FormData.fromMap(highlights.toJson()));

    return _resp.data['success'];
  }

}
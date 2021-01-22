import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/feature/setting/domain/entities/update_entity.dart';

abstract class SettingRemoteDataSource {
  Future<UpdateEntity> checkVersion();
}
class SettingRemoteDataSourceImpl implements SettingRemoteDataSource {
  final CDio cDio;

  SettingRemoteDataSourceImpl({this.cDio});
  @override
  Future<UpdateEntity> checkVersion() async {
    Response _resp;
    try {
     _resp = await cDio.getResponse(path: 'auth/version');
     return UpdateEntity.formJson(_resp.data['data']);
    }catch(e){
      return null;
    }

  }

}
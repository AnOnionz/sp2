import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

abstract class SendRequirementLocalDataSource {
 List<String> fetchRequirement();

  Future<void> cacheRequirement(String message);

  Future<void> clearRequirement();

 Future<void> clearAllRequirement();

 bool isRequireSync();
}
class SendRequirementLocalDataSourceImpl implements SendRequirementLocalDataSource{
  final SyncLocalDataSource syncLocal;

  SendRequirementLocalDataSourceImpl({this.syncLocal});
  @override
  Future<void> cacheRequirement(String message) async {
   Box<String> box = Hive.box(AuthenticationBloc.outlet.id.toString() + SEND_REQUIREMENT);
   await box.add(message);
   await syncLocal.addSync(type: 1, value: 1);
  }

  @override
  List<String> fetchRequirement() {
    Box<String> box = Hive.box(AuthenticationBloc.outlet.id.toString() + SEND_REQUIREMENT);
    return box.values.toList();
  }

  @override
  Future<void> clearRequirement() async {
   await syncLocal.removeSync(type: 1, value: 1);
  }

  @override
  Future<void> clearAllRequirement() async {
    Box<String> box = Hive.box(AuthenticationBloc.outlet.id.toString() + SEND_REQUIREMENT);
    await box.clear();
  }

  @override
  bool isRequireSync() {
    Box<String> box = Hive.box(AuthenticationBloc.outlet.id.toString() + SEND_REQUIREMENT);
    return box.isNotEmpty;
  }

}
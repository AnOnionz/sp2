import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/setting/domain/entities/update_entity.dart';
import 'package:sp_2021/feature/setting/domain/usecases/setting_usecase.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingUseCase checkVersion;
  SettingBloc({this.checkVersion}) : super(SettingInitial()){
    add(SettingStart());
    add(CheckVersion());
  }

  @override
  Stream<SettingState> mapEventToState(
    SettingEvent event,
  ) async* {
    if(event is SettingStart){
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        await Permission.storage.request();
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      yield SettingLoaded(packageInfo: packageInfo);
    }
    if(event is CheckVersion){
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final versionCurrent = await checkVersion(NoParams());
     yield versionCurrent.fold((l) => NoRequireUpdateApp(), (r) => RequireUpdateApp(updateEntity: r, packageInfo: packageInfo));
    }
  }
}

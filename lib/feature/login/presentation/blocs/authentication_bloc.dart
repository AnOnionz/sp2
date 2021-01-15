import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/storage/hive_db.dart' as hive;
import 'package:sp_2021/feature/login/data/model/login_model.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';


import '../../../../di.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SharedPreferences sharedPreferences;
  static LoginEntity outlet;
  AuthenticationBloc({@required this.sharedPreferences}) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      requestPermission();
      try {
        // user from login success
        String outletString = sharedPreferences.getString(OUTLET_IN_STORAGE);
        outlet =  outletString !=null ? LoginModel.fromJson(jsonDecode(outletString)) : null;
        if (outlet != null) {
          print('OUTLET:' + outlet.toString());
          await hive.initDB();
          Future.delayed(Duration.zero);
          yield AuthenticationAuthenticated(outlet: outlet);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (e, s) {
        print(e);
        print(s);
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      sharedPreferences.setString(OUTLET_IN_STORAGE, jsonEncode(event.loginEntity.toJson()));
      outlet = event.loginEntity;
      await hive.initDB();
      Future.delayed(Duration.zero);
      yield AuthenticationAuthenticated(outlet: event.loginEntity);
    }

    if (event is LoggedOut) {
      sharedPreferences.remove(OUTLET_IN_STORAGE);
      yield AuthenticationUnauthenticated();
    }
    if (event is ShutDown) {
      yield AuthenticationDuplicated(willPop: event.willPop);
    }
  }
 Future<LoginEntity> getUser() async{
   final jsonString = sl<SharedPreferences>().getString(OUTLET_IN_STORAGE);
   return LoginModel.fromJson(jsonDecode(jsonString));
 }
  requestPermission() async {
    var camera = await Permission.camera.status;
    if (camera != PermissionStatus.granted) {
      await Permission.camera.request();
    }
    var storage = await Permission.storage.status;
    if (storage != PermissionStatus.granted) {
      await Permission.storage.request();
    }
    var location = await Permission.location.status;
    if (location != PermissionStatus.granted) {
      await Permission.location.request();
    }
    var notification = await Permission.notification.status;
    if (notification != PermissionStatus.granted) {
      await Permission.notification.request();
    }
  }

}

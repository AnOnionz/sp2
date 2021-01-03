import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sp_2021/feature/login/data/model/login_model.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';

class SecureStorage extends FlutterSecureStorage {
  Future<void> writeOutlet({@required String key,
    @required LoginEntity value}) {
    return super.write(
        key: key,
        value: jsonEncode(value.toJson()));
  }

  Future<LoginEntity> readOutlet({@required String key}) async {
    String response =
    await super.read(key: key);
    Map<String, dynamic> json = jsonDecode(response);
    return LoginModel.fromJson(json);
  }

  Future<void> cacheState(
      {@required String key, @required ReceiveGiftState state}) {
    return super.write(
        key: key,
        value: jsonEncode(state.toJson()));
  }
  Future<ReceiveGiftState> readState({@required String key}) async {
    String response = await super.read(key: key);
    Map<String, dynamic> json = jsonDecode(response);
    return ReceiveGiftState.fromJson(json);
  }
}

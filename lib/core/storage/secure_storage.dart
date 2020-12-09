import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sp_2021/feature/login/data/model/login_model.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

class SecureStorage extends FlutterSecureStorage {
  Future<void> writeUser(
      {@required String key,
      @required LoginEntity value}) {
    return super.write(
        key: key,
        value: jsonEncode(value.toJson()));
  }

  Future<LoginEntity> readUser<T>(
      {@required String key}) async {
    String response =
        await super.read(key: key);
    Map<String, dynamic> json = jsonDecode(response);
    return LoginModel.fromJson(json);
  }
}

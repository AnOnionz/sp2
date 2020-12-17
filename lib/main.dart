import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'di.dart' as di;
import 'package:sp_2021/core/storage/hive_db.dart' as hive;
import 'my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await hive.init();
  ByteDataAssets.instance.basePath = "assets/images/";
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(MyApplication());
  });
}

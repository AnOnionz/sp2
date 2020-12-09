import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/util/custom_dialog.dart';
import 'di.dart' as di;
import 'my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  ByteDataAssets.instance.basePath = "assets/images/";
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(MyApplication());
  });
}

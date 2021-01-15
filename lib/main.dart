import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/simple_bloc_observer.dart';
import 'package:wakelock/wakelock.dart';
import 'core/platform/date_time.dart';
import 'di.dart' as di;
import 'package:sp_2021/core/storage/hive_db.dart' as hive;
import 'my_application.dart';


const _flareFile =[
  'assets/images/correct.flr',
  'assets/images/Error.flr',
  'assets/images/no_available.flr',
  'assets/images/no_internet.flr',
  'assets/images/notification.flr',
];

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  binding.addPostFrameCallback((_) async {
    BuildContext context = binding.renderViewElement;
    if(context != null)
    {
      precacheImage(AssetImage("assets/images/background.png"), context);
      precacheImage(AssetImage("assets/images/Logo HNK - VN_White 2.png"), context);
    }
  });
  cacheFlare();
  await MyDateTime.getToday();
  await di.init();
  await hive.init();
  MyPackageInfo().getPackageInfo();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await Wakelock.enable();
    runApp(MyApplication());
  });
}
Future<void> cacheFlare() async {
  for(final flare in _flareFile){
    await cachedActor(AssetFlare(bundle: rootBundle, name: flare),);
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }
}

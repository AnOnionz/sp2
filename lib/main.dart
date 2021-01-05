import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sp_2021/simple_bloc_observer.dart';
import 'core/platform/date_time.dart';
import 'di.dart' as di;
import 'package:sp_2021/core/storage/hive_db.dart' as hive;
import 'my_application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await MyDateTime.getToday();
  await di.init();
  await hive.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await SentryFlutter.init(
          (options) {
        options..dsn =
            'https://7b09fb656f9f4d5198f1c5f2297851d9@o496763.ingest.sentry.io/5571917'..addEventProcessor(processTagEvent);
      },
      appRunner: () => runApp(MyApplication()),
    );
  });
}
SentryEvent processTagEvent(SentryEvent event, {dynamic hint}) =>
    event..tags;

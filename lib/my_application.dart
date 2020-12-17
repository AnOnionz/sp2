import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sp_2021/feature/highlight/presentation/screens/highlight_page.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_page.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/screens/rival_sale_price_page.dart';
import 'package:sp_2021/feature/sale_price/presentation/screens/sale_price_page.dart';
import 'package:sp_2021/feature/sync_data/presentation/screens/sync_data.dart';
import 'core/api/myDio.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';
import 'di.dart';
import 'feature/attendance/presentation/blocs/map_bloc.dart';
import 'feature/inventory/presentation/screens/inventory_page.dart';
import 'feature/login/presentation/blocs/authentication_bloc.dart';
import 'feature/dashboard/presentation/screens/dashboard.dart';
import 'feature/login/presentation/screens/login_page.dart';

Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
class MyApplication extends StatefulWidget {
  const MyApplication();

  @override
  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  String _deviceToken;
  List<FcmEntity> messages = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<String> _getDeviceToken() async {
    await _firebaseMessaging.getToken().then((deviceToken) {
      _deviceToken = deviceToken;
    });

    print('Device ID: $_deviceToken');
    return _deviceToken;
  }


  @override
  void initState() {
    super.initState();
    _getDeviceToken();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(FcmEntity(
              title: notification['title'], body: notification['body']));
        });
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(FcmEntity(
            title: '${notification['title']}',
            body: '${notification['body']}',
            screen: '${notification['tab']}',
            tab: notification['tab'] as int,
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    messages.forEach((e) => print(e));
    var _routes = {
      '/receive_gift': (context) => ReceiveGiftPage(),
      '/sale_price': (context) => SalePricePage(),
      '/rival_sale': (context) => RivalSalePricePage(),
      '/inventory': (context) => InventoryPage(),
      '/highlight': (context) => HighLightPage(),
      '/sync_data': (context) => SyncDataPage(),
    };

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(
              builder: (context) => _routes[settings.name](context));
        },
        home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(
                create: (_) => sl<AuthenticationBloc>()..add(AppStarted()),
              ),
              BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
              BlocProvider<MapBloc>(create: (_) => sl<MapBloc>()),
            ],
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationLoading) {
                  return Scaffold(
                    body: const Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  );
                }
                if (state is AuthenticationUnauthenticated) {
                  return LoginPage(deviceId: "abc");
                }
                if (state is AuthenticationAuthenticated) {
                  sl<CDio>().setBearerAuth(state.user.accessToken);
                  return DashboardPage();
                }
                return Container(
                  color: Colors.white,
                );
              },
            )));
  }
}

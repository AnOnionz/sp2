import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ota_update/ota_update.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/save_to_local_usecase.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/highlight/presentation/screens/highlight_page.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_page.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/screens/rival_sale_price_page.dart';
import 'package:sp_2021/feature/sale_price/presentation/screens/sale_price_page.dart';
import 'package:sp_2021/feature/sync_data/presentation/screens/sync_data_page.dart';
import 'package:sp_2021/update_ver_page.dart';
import 'core/api/myDio.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';
import 'core/common/text_styles.dart';
import 'core/platform/notify.dart';
import 'di.dart';
import 'feature/attendance/domain/entities/attendance_type.dart';
import 'feature/attendance/presentation/blocs/map_bloc.dart';
import 'feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'feature/inventory/presentation/screens/inventory_page.dart';
import 'feature/login/presentation/blocs/authentication_bloc.dart';
import 'feature/dashboard/presentation/screens/dashboard.dart';
import 'feature/login/presentation/screens/login_page.dart';
import 'feature/notification/data/datasources/notification_local_data_source.dart';
import 'feature/setting/domain/entities/update_entity.dart';
import 'feature/setting/domain/usecases/setting_usecase.dart';

class MyApplication extends StatefulWidget {

  const MyApplication();

  @override
  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  String _deviceToken;
  SettingUseCase checkVersion;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final globalKey = GlobalKey<NavigatorState>();
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
    sl<CDio>().setHeader(int.parse(MyPackageInfo.packageInfo.version.toString().replaceAll('.', '')));
    _getDeviceToken();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        FcmEntity fcm = FcmEntity(
          title: '${message['notification']['title']}',
          body: '${message['notification']['body']}',
          time: DateTime.now(),
          tab: message['data']['tab'] !=null ? int.parse(message['data']['tab']): null,
          screen:  message['data']['screen'] != null ? message['data']['screen'] : null,
          isClick: false,
        );
        _saveFcmToLocal(fcm);
        if(fcm.tab == 6){
          sl<SaveDataToLocalUseCase>()(NoParams());
        }
      },
      onBackgroundMessage: NotifyManager.myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        FcmEntity fcm = FcmEntity(
          title: '${message['notification']['title']}',
          body: '${message['notification']['body']}',
          time: DateTime.now(),
          tab: message['data']['tab'] !=null ? int.parse(message['data']['tab']): null,
          screen: message['data']['screen'] != null ? message['data']['screen'] : null,
          isClick: true,
        );
        _generateRouteWhenReceiveMessage(fcm);
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
        FcmEntity fcm = FcmEntity(
          title: '${message['notification']['title']}',
          body: '${message['notification']['body']}',
          time: DateTime.now(),
          tab: message['data']['tab'] !=null ? int.parse(message['data']['tab']): null,
          screen:  message['data']['screen'] != null ? message['data']['screen'] : null,
          isClick: true,
        );
        _generateRouteWhenReceiveMessage(fcm);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    checkVersion = sl<SettingUseCase>();
  }
  _saveFcmToLocal(FcmEntity fcm) async {
    await sl<NotificationLocalDataSource>().cacheNotification(fcm: fcm);
  }
  _generateRouteWhenReceiveMessage(FcmEntity fcm) async {
    if(fcm.tab != null){
      if(fcm.tab == 6){
        sl<SaveDataToLocalUseCase>()(NoParams());
        return;
      }
      if(fcm.tab == 7){
        final version = await checkVersion(NoParams());
        version.fold((l) => null, (r) => int.parse(r.version.toString().replaceAll(".", "")) > int.parse(MyPackageInfo.packageInfo.version.toString().replaceAll(".", "")) ? tryOtaUpdate(r) : null);
        return;
      }
      sl<TabBloc>().add(TabPressed(index: fcm.tab));
    }
    if(fcm.screen != null){
      globalKey.currentState.pushNamed(fcm.screen);
      return;
    }
    sl<TabBloc>().add(TabPressed(index: 4));

  }

  Future<void> tryOtaUpdate(UpdateEntity updateEntity) async {
    final fileName = 'SpTOft2021_V1.apk';
    try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      File oldVersion = File('$path/$fileName');
      if (oldVersion.existsSync()) {
        await oldVersion.delete();
      }
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        updateEntity.url,
        destinationFilename: fileName,
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _routes = {
      '/receive_gift': (context) => ReceiveGiftPage(),
      '/sale_price': (context) => SalePricePage(),
      '/rival_sale': (context) => RivalSalePricePage(),
      '/inventory': (context) => InventoryPage(),
      '/highlight': (context) => HighLightPage(),
      '/sync_data': (context) => SyncDataPage(),
      '/update': (context) => UpdateVerPage(),
    };

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalKey,
        theme: ThemeData(
          unselectedWidgetColor: Colors.teal,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(
              maintainState: true,
              builder: (context) => _routes[settings.name](context));
        },
        home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(
                create: (_) => sl<AuthenticationBloc>()..add(AppStarted()),
              ),
              BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
              BlocProvider<MapBloc>(create: (_) => sl<MapBloc>()),
              BlocProvider<DashboardBloc>( create: (_) => sl<DashboardBloc>()),
              BlocProvider<TabBloc>( create: (_) => sl<TabBloc>()),
            ],
            child: BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if(state is AuthenticationDuplicated){
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: ZoomIn(
                            duration: Duration(milliseconds: 100),
                            child: CupertinoAlertDialog(
                              title: Text('Thông báo'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Phiên đăng nhập đã hết hạn", style: Subtitle1black,),
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text('Đăng nhập'),
                                  onPressed: () {
                                    List.generate(state.willPop, (index) => Navigator.pop(context));
                                    sl<AuthenticationBloc>().add(LoggedOut());
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationLoading) {
                      return Scaffold(
                        body: Center(child: CupertinoActivityIndicator(radius: 20, animating: true,),
                        ),
                      );
                    }
                    if (state is AuthenticationUnauthenticated) {
                      return LoginPage(deviceId: _deviceToken);
                    }
                    if (state is AuthenticationAuthenticated) {
                      sl<CDio>().setBearerAuth(state.outlet.accessToken);
                      if(!sl<DashBoardLocalDataSource>().dataToday.checkIn)
                      sl<AttendanceRemoteDataSource>().checkSP().then((value)
                      {
                        if(value is CheckOut){
                          sl<DashBoardLocalDataSource>().cacheDataToday(checkIn: true, checkOut: false);
                        }
                      });
                      sl<TabBloc>().add(TabPressed(index: 0));
                      BlocProvider.of<DashboardBloc>(context).add(SaveServerDataToLocalData());
                      return DashboardPage();
                    }
                    return Scaffold(
                      body: Container(
                        child: Center(child: CupertinoActivityIndicator(radius: 20, animating: true,)),
                      ),
                    );
                  //return NewDomainPage();
                  },
                ),
            )
        )
    );
  }
}
import 'dart:io';
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/attendance/presentation/screens/attendance_page.dart';
import 'package:sp_2021/feature/check_voucher/presentation/screens/check_voucher_page.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'package:sp_2021/feature/notification/presentation/screens/notification_page.dart';
import 'package:sp_2021/feature/send_requirement/presentation/screens/send_requirement_page.dart';
import 'package:sp_2021/feature/setting/presentation/screens/setting_page.dart';
import 'home_page.dart';

class DashboardPage extends StatelessWidget {

  final _children = [
    HomePage(),
    AttendancePage(),
    ProductRequirementPage(),
    CheckVoucherPage(),
    NotificationPage(),
    SettingPage(),
  ];
  openSettingsMenu(settingsName) async {
    var resultSettingsOpening = false;
    try {
      resultSettingsOpening =
      await AccessSettingsMenu.openSettings(settingsType: settingsName);
    } catch (e) {
      resultSettingsOpening = false;
    }
  }

  BlocBuilder<TabBloc, TabState> _bottomNavigationBar() {
    return BlocBuilder<TabBloc, TabState>(builder: (context, state) {
      if (state is TabChanged) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BottomNavigationBar(
              currentIndex: state.index,
              onTap: (index) {
                BlocProvider.of<TabBloc>(context)
                    .add(TabPressed(index: index));
              },
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              selectedLabelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              selectedItemColor: Colors.white,
              unselectedLabelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedItemColor: Colors.white.withOpacity(0.3),
              items: [
                BottomNavigationBarItem(
                    icon: AnimatedOpacity(
                        duration: Duration.zero,
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/images/home.png",
                          height: 30,
                        )),
                    activeIcon: Image.asset(
                      "assets/images/home.png",
                      height: 30,
                    ),
                    label: 'Trang chủ'),
                BottomNavigationBarItem(
                    icon: AnimatedOpacity(
                        duration: Duration.zero,
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/images/calendar.png",
                          height: 30,
                        )),
                    activeIcon: Image.asset(
                      "assets/images/calendar.png",
                      height: 30,
                    ),
                    label: 'Chấm công'),
                BottomNavigationBarItem(
                    icon: AnimatedOpacity(
                        duration: Duration.zero,
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/images/box.png",
                          height: 30,
                        )),
                    activeIcon: Image.asset(
                      "assets/images/box.png",
                      height: 30,
                    ),
                    label: 'Yêu cầu hàng'),
                BottomNavigationBarItem(
                  icon: AnimatedOpacity(
                      duration: Duration.zero,
                      opacity: 0.3,
                      child: Image.asset(
                        "assets/images/e-voucher.png",
                        height: 30,
                      )),
                  activeIcon: Image.asset(
                    "assets/images/e-voucher.png",
                    height: 30,
                  ),
                  label: 'Kiểm tra giảm giá',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      AnimatedOpacity(
                          duration: Duration.zero,
                          opacity: 0.3,
                          child: Image.asset(
                            "assets/images/bell.png",
                            height: 30,
                          )),
                      Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 13,
                            minHeight: 13,
                          ),
                          child: new Text(
                            '9+',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  activeIcon: Column(
                    children: [
                      Image.asset(
                        "assets/images/bell.png",
                        height: 30,
                      ),
                    ],
                  ),
                  label: 'Thông báo',
                ),
                BottomNavigationBarItem(
                  icon: AnimatedOpacity(
                      duration: Duration.zero,
                      opacity: 0.3,
                      child: Image.asset(
                        "assets/images/settings.png",
                        height: 30,
                      )),
                  activeIcon: Image.asset(
                    "assets/images/settings.png",
                    height: 30,
                  ),
                  label: 'Cài đặt',
                ),
              ]),
        );
      }
      return Container(
        child: Text("Đã xảy ra lỗi"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Bạn có chắc muốn tắt ứng dụng?', style: Subtitle1black,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Hủy',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(false)),
            FlatButton(
              child: Text(
                'Đồng ý',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                SystemNavigator.pop();
                exit(0);
              },
            ),
          ],
        ),
      ),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
              child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: BlocBuilder<TabBloc, TabState>(
              builder: (context, state) {
                if (state is TabChanged) {
                  return BlocListener<DashboardBloc, DashboardState>(
                      listener: (context, state) {
                        if (state is DashboardSaving) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white60.withOpacity(0.2),
                                ),
                                child: CupertinoActivityIndicator(
                                  radius: 20,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is DashboardHasSync) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => ZoomIn(
                                duration: const Duration(milliseconds: 100),
                                child: CupertinoAlertDialog(
                                      title: Text("Yêu cầu đồng bộ"),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(state.message,  style: Subtitle1black,),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                            isDefaultAction: true,
                                            textStyle:
                                                TextStyle(color: Colors.red),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Thoát")),
                                        CupertinoDialogAction(
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, '/sync_data');
                                            },
                                            child: Text("Đồng bộ")),
                                      ],
                                    ),
                              ));
                        }
                        if (state is DashboardRequiredCheckInOrOut) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => ZoomIn(
                                duration: const Duration(milliseconds: 100),
                                child: CupertinoAlertDialog(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Yêu cầu chấm công"),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(state.message,  style: Subtitle1black,),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: true,
                                        textStyle:
                                        TextStyle(color: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Hủy")),
                                    CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: (){
                                          List.generate(state.willPop, (i){Navigator.pop(context);});
                                          BlocProvider.of<TabBloc>(context).add(TabPressed(index: 1));
                                        },
                                        child: Text("Chấm công")),
                                  ],
                                ),
                              ));
                        }
                        if (state is DashboardNoInternet) {
                          print(132321331);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => ZoomIn(
                                duration: Duration(milliseconds: 100),
                                child: CupertinoAlertDialog(
                                  title: Text("Thông báo"),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Không có kết nối Internet", style: Subtitle1black,),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: true,
                                        textStyle:
                                        TextStyle(color: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Đóng")),
                                    CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          openSettingsMenu('ACTION_WIRELESS_SETTINGS');
                                        },
                                        child: Text("Cài đặt")),
                                  ],
                                ),
                              ));
                        }
                        if (state is DashboardSaved) {
                          Navigator.pop(context);
                        }
                        if (state is DashboardFailure) {
                          Navigator.pop(context);
                          Dialogs().showMessageDialog(context: context, content: state.message);
                        }
                      },
                      child: IndexedStack(index: state.index, children: _children,),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
          bottomNavigationBar: _bottomNavigationBar(),
        ),
    );
  }
}

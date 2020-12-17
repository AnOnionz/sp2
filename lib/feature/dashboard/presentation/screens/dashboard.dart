import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/util/custom_dialog.dart' as Dialogs;
import 'package:sp_2021/feature/attendance/presentation/screens/attendance_page.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'package:sp_2021/feature/notification/presentation/screens/notification_page.dart';
import 'package:sp_2021/feature/product_requirement/presentation/screens/product_requirement.dart';
import 'package:sp_2021/feature/setting/presentation/screens/setting_page.dart';
import '../../../../di.dart';
import 'home_page.dart';

class DashboardPage extends StatelessWidget {
  final _children = [
    HomePage(),
    AttendancePage(),
    ProductRequirementPage(),
    NotificationPage(),
    SettingPage(),
  ];

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
                    .add(TabPressed(_children[index], index: index));
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
                    label: 'Yêu cầu quà'),
                BottomNavigationBarItem(
                  icon: AnimatedOpacity(
                      duration: Duration.zero,
                      opacity: 0.3,
                      child: Image.asset(
                        "assets/images/bell.png",
                        height: 30,
                      )),
                  activeIcon: Image.asset(
                    "assets/images/bell.png",
                    height: 30,
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
            'Bạn có chắc muốn tắt ứng dụng?',
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<TabBloc>(),
          ),
          BlocProvider(
            create: (_) => sl<DashboardBloc>(),
          ),
        ],
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
                        if (state is DashboardSaved) {
                          Navigator.pop(context);
                        }
                        if (state is DashboardSaveFailure) {
                          print("error");
                        }
                      },
                      child: state.child);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
          bottomNavigationBar: _bottomNavigationBar(),
        ),
      ),
    );
  }
}

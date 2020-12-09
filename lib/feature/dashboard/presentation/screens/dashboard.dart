import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/util/FutureImage.dart';
import 'package:sp_2021/feature/attendance/presentation/screens/attendance_page.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'package:sp_2021/feature/notification/presentation/screens/notification_page.dart';
import 'package:sp_2021/feature/setting/presentation/screens/setting_page.dart';
import '../../../../di.dart';
import 'home_page.dart';

class DashboardPage extends StatelessWidget {

  final _children = [HomePage(), AttendancePage(), NotificationPage(), SettingPage(),];

  BlocBuilder<TabBloc,TabState> _bottomNavigationBar() {
    return BlocBuilder<TabBloc, TabState>(
        builder: (context, state) {
          if(state is TabChanged){
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (index){
                    BlocProvider.of<TabBloc>(context).add(TabPressed(_children[index], index: index));
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
                            child:Image.asset("assets/images/home-run.png", height: 30,)),
                        activeIcon: Image.asset("assets/images/home-run.png", height: 30,),
                        label: 'Trang chủ'
                    ),
                    BottomNavigationBarItem(
                        icon: AnimatedOpacity(
                            duration: Duration.zero,
                            opacity: 0.3,
                            child: Image.asset("assets/images/calendar.png", height: 30,)),
                        activeIcon: Image.asset("assets/images/calendar.png", height: 30,),
                        label: 'Chấm công'
                    ),
                    BottomNavigationBarItem(
                      icon: AnimatedOpacity(
                          duration: Duration.zero,
                          opacity: 0.3,
                          child:
                          Image.asset("assets/images/notification.png", height: 30,)),
                      activeIcon: Image.asset("assets/images/notification.png", height: 30,),
                      label:'Thông báo',
                    ),
                    BottomNavigationBarItem(
                      icon: AnimatedOpacity(
                          duration: Duration.zero,
                          opacity: 0.3,
                          child: Image.asset("assets/images/settings.png", height: 30,)),
                          activeIcon:
                          Image.asset("assets/images/settings.png", height: 30,),
                            label: 'Cài đặt',
                    ),
                  ]
              ),
            );
          }
          return Container(child: Text("Đã xảy ra lỗi"),);

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
                      ),
                      onPressed: () => Navigator.of(context).pop(false)),
                  FlatButton(
                    child: Text(
                      'Đồng ý',
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                      exit(0);
                    },
                  )
                ],
              ),
            ),
        child: BlocProvider(
          create: (_) => sl<TabBloc>(),
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SafeArea(
                child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
                  child: BlocBuilder<TabBloc, TabState>(
                    builder: (context, state) {
                      if(state is TabChanged){
                        return state.child;
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
            )),
            bottomNavigationBar: _bottomNavigationBar(),
          ),
        ));
  }
}

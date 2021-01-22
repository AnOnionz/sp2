import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'package:sp_2021/feature/notification/data/datasources/notification_local_data_source.dart';

import '../../../../di.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, TabState>(
        builder: (context, state) {
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
                BlocProvider.of<TabBloc>(context).add(TabPressed(index: index));
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
                  label: 'Lịch sử sử dụng mã giảm giá',
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
                      StreamBuilder(
                          initialData: sl<NotificationLocalDataSource>().numberOfNotify(),
                          stream: sl<NotificationLocalDataSource>().notify,
                          builder: (context, snapshot) => snapshot.data > 0
                              ? Positioned(
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
                                    child: Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Positioned(
                                  right: 0,
                                  child: new Container(
                                    padding: EdgeInsets.all(1),
                                    constraints: BoxConstraints(
                                      minWidth: 13,
                                      minHeight: 13,
                                    ),
                                  ))),
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
        child: Center(child: Text("Đã xảy ra lỗi")),
      );
    });
  }
}

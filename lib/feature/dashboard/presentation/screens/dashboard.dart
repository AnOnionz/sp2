import 'dart:io';
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
import 'package:sp_2021/feature/dashboard/presentation/widgets/bottom_bar.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';
import 'package:sp_2021/feature/notification/presentation/screens/notification_page.dart';
import 'package:sp_2021/feature/send_requirement/presentation/screens/send_requirement_page.dart';
import 'package:sp_2021/feature/setting/presentation/screens/setting_page.dart';
import '../../../../di.dart';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(
            'Bạn có chắc muốn tắt ứng dụng?',
            style: Subtitle1black,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  'Hủy',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(false)),
            CupertinoDialogAction(
              textStyle: TextStyle(color: Colors.red),
              isDefaultAction: true,
              child: Text(
                'Đồng ý',
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
            builder: (context, tabState) {
              if (tabState is TabChanged) {
                return BlocConsumer<DashboardBloc, DashboardState>(
                  listener: (context, state) {
                    if (state is DashboardRequiredUpdate) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: ZoomIn(
                                duration: const Duration(milliseconds: 100),
                                child: CupertinoAlertDialog(
                                  title: Text("Thông báo"),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '''Phải cập nhật phiên bản mới ngay bây giờ 
                                          để có thể tiếp tục dùng ứng dụng''',
                                      style: Subtitle1black,
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: true,
                                      child: Text("Đăng xuất và cập nhật"),
                                      onPressed: () async {
                                        try {
                                          BlocProvider.of<
                                              LoginBloc>(
                                              context)
                                              .add(
                                              LogoutButtonPress());
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WillPopScope(
                                                  onWillPop: () async => false,
                                                  child: ZoomIn(
                                                    duration: const Duration(milliseconds: 100),
                                                    child: CupertinoAlertDialog(
                                                      content: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Đang đăng xuất",
                                                          style: Subtitle1black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });

                                        } catch (e) {
                                          Navigator.pop(context);
                                          Dialogs().showFailureAndRetryDialog(
                                              context: context,
                                              content:
                                              "Đã xảy ra lỗi",
                                              reTry: () async {
                                                Navigator.pop(context);
                                                BlocProvider.of<
                                                    LoginBloc>(
                                                    context)
                                                    .add(
                                                    LogoutButtonPress());
                                              });
                                        }
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    if (state is DashboardSaving) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => WillPopScope(
                                onWillPop: () async => false,
                                child: Center(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white70,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CupertinoActivityIndicator(
                                          radius: 20,
                                          animating: true,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                "Đang tải",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    }
                    if (state is DashboardNoInternetInitData) {
                      Navigator.pop(context);
                      Dialogs().showFailureAndRetryDialog(
                          context: context,
                          content: '''Tải dữ liệu không thành công
                                                                                vui lòng kiểm tra kết nối mạng''',
                          reTry: () {
                            Navigator.pop(context);
                            sl<DashboardBloc>()
                                .add(SaveServerDataToLocalData());
                          });
                    }
                    if (state is DashboardHasSync) {
                      Dialogs().showRequireSyncDialog(
                        context: context,
                        content: state.message,
                      );
                    }
                    if (state is DashboardRequiredCheckInOrOut) {
                      Dialogs().showRequireAttendanceDialog(
                          context: context,
                          content: state.message,
                          attendance: () {
                            List.generate(state.willPop, (i) {
                              Navigator.pop(context);
                            });
                            BlocProvider.of<TabBloc>(context)
                                .add(TabPressed(index: 1));
                          });
                    }
                    if (state is DashboardNoInternet) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => WillPopScope(
                              onWillPop: () async => false,
                              child: ZoomIn(
                                duration: Duration(milliseconds: 100),
                                child: CupertinoAlertDialog(
                                  title: Text("Không có kết nối mạng"),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Vui lòng kiểm tra kết nối mạng và thử lại",
                                      style: Subtitle1black,
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Đóng")),
                                  ],
                                ),
                              )));
                    }
                    if (state is DashboardSaved) {
                      Navigator.pop(context);
                    }
                    if (state is DashboardRefresh) {
                      Navigator.pop(context);
                      Dialogs().showSuccessDialog(
                          context: context, content: "Dữ liệu đã được làm mới");
                    }
                    if (state is DashboardFailure) {
                      state.willPop == 1
                          ? Navigator.of(context).pop(true)
                          : (){}();
                      Dialogs().showFailureDialog(
                          context: context, content: state.message);
                    }
                  },
                  builder: (context, state) {
                    return _children[tabState.index];
                  },
                );
              }
              return Scaffold(
                body: Container(
                  child: Center(
                      child: CupertinoActivityIndicator(
                    radius: 20,
                    animating: true,
                  )),
                ),
              );
            },
          ),
        )),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

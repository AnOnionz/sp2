import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ota_update/ota_update.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:sp_2021/feature/setting/domain/entities/update_entity.dart';
import 'package:sp_2021/feature/setting/presentation/blocs/setting_bloc.dart';
import 'package:ext_storage/ext_storage.dart';

import '../../../../di.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  OtaEvent currentEvent;
  PackageInfo packageInfo;
  double percent = 0;
  bool _enable = true;

  @override
  void initState() {
    super.initState();
    packageInfo = MyPackageInfo.packageInfo;
  }

  Future<void> tryOtaUpdate(UpdateEntity updateEntity) async {
    final fileName = 'SpTOft2021_V1.apk';
    setState(() {
      _enable = false;
    });
     try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      File oldVersion = File('$path/$fileName');
      if (oldVersion.existsSync()) {await oldVersion.delete();}
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        updateEntity.url,
        destinationFilename: fileName,
      )
          .listen(
        (OtaEvent event) {
          setState(() => currentEvent = event);
          if (event.status == OtaStatus.DOWNLOADING) {
            setState(() {
              percent = double.parse(
                  (int.parse(event.value) / 100).toStringAsFixed(1));
            });
          }else{
            setState(() {
              _enable = true;
            });
          }
        },
      );
    } catch (e) {
       setState(() {
         _enable = true;
       });
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:FloatingActionButton(
          onPressed: (){
            sl<DashboardBloc>().add(RefreshApp());
          },
          backgroundColor: Colors.teal,
          hoverColor: Colors.blueAccent,
          child: Icon(Icons.autorenew_outlined, size: 35, color: Colors.cyanAccent,),
        ),
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: BlocProvider<SettingBloc>(
                  create: (_) => sl<SettingBloc>(),
                  child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                                    child: const Text(
                                      'CÀI ĐẶT',
                                      style: header,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0, bottom: 18.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ứng dụng",
                                              style: Subtitle1white,
                                            ),
                                            Text(
                                              packageInfo.appName,
                                              style: Subtitle1white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0, bottom: 18.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Phiên bản",
                                              style: Subtitle1white,
                                            ),
                                            Text(
                                              packageInfo.version,
                                              style: Subtitle1white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0, bottom: 25.0),
                                        child: Text(
                                          "Ứng dụng được phát triển bởi IMARK",
                                          style: Subtitle1white,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        height: 1,
                                      ),
//                                      BlocBuilder<SettingBloc, SettingState>(
//                                        builder: (context, state) {
//                                          if (state is RequireUpdateApp && state.updateEntity !=null &&
//                                              (int.parse(packageInfo.version.toString().replaceAll(".", ""))) <
//                                                  int.parse(state.updateEntity.version.toString().replaceAll(".", ""))) {
//                                            return Padding(
//                                              padding: const EdgeInsets.only(
//                                                  top: 18.0, bottom: 18.0),
//                                              child: Row(
//                                                mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceBetween,
//                                                children: [
//                                                  Text(
//                                                    "Bản cập nhật ${state.updateEntity.version}",
//                                                    style: Subtitle1white,
//                                                  ),
//                                                  !_enable && currentEvent !=null &&
//                                                          currentEvent.status ==
//                                                              OtaStatus
//                                                                  .DOWNLOADING
//                                                      ? Container(
//                                                          height: 45,
//                                                          width: 45,
//                                                          child: Stack(
//                                                            children: [
//                                                              Align(
//                                                                alignment:
//                                                                    Alignment
//                                                                        .center,
//                                                                child: Center(
//                                                                  child:
//                                                                      Container(
//                                                                    height: 15,
//                                                                    width: 15,
//                                                                    decoration: BoxDecoration(
//                                                                        color: Colors
//                                                                            .blue,
//                                                                        borderRadius:
//                                                                            BorderRadius.circular(5.0)),
//                                                                  ),
//                                                                ),
//                                                              ),
//                                                              Align(
//                                                                alignment:
//                                                                    Alignment
//                                                                        .center,
//                                                                child:
//                                                                    CircularProgressIndicator(
//                                                                  valueColor: AlwaysStoppedAnimation<
//                                                                          Color>(
//                                                                      Colors
//                                                                          .blue),
//                                                                  value:
//                                                                      percent,
//                                                                  strokeWidth:
//                                                                      3,
//                                                                ),
//                                                              )
//                                                            ],
//                                                          ),
//                                                        )
//                                                      : IconButton(
//                                                          icon: Icon(
//                                                            Icons
//                                                                .download_sharp,
//                                                            color: Colors
//                                                                .lightBlueAccent,
//                                                            size: 25,
//                                                          ),
//                                                          onPressed: _enable ? ()  {
//                                                           // await sl<LoginRemoteDataSource>().logout();
//                                                            tryOtaUpdate(state
//                                                                .updateEntity);
//                                                          } : (){})
//                                                ],
//                                              ),
//                                            );
//                                          }
//                                          if (state is RequireUpdateApp && state.updateEntity != null &&
//                                              (int.parse(packageInfo.version.toString().replaceAll(".", ""))) ==
//                                                  int.parse(state.updateEntity.version.toString().replaceAll(".", ""))) {
//                                            return Padding(
//                                                padding: const EdgeInsets.only(
//                                                    top: 18.0, bottom: 18.0),
//                                                child: Row(
//                                                    mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceBetween,
//                                                    children: [
//                                                      Text(
//                                                        "Đây là phiên bản mới nhất",
//                                                        style: Subtitle1white,
//                                                      ),]));
//                                          }
//                                          return Container();
//                                        },
//                                      ),
                                      BlocConsumer<LoginBloc, LoginState>(
                                        builder: (context, state) => InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CupertinoAlertDialog(
                                                title: Text("Đăng xuất ?"),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Bạn có chắc muốn đăng xuất ?",
                                                    style: Subtitle1black,
                                                  ),
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    child: Text("Hủy"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    textStyle: TextStyle(
                                                        color: Colors.red),
                                                    child: Text("Đăng xuất"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      BlocProvider.of<
                                                                  LoginBloc>(
                                                              context)
                                                          .add(
                                                              LogoutButtonPress());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 50,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Đăng xuất",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                        listener: (context, state) {
                                          if (state is LogoutCloseDialog) {
                                            Navigator.pop(context);
                                          }
                                          if (state is LogoutLoading) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  content: Column(
                                                    children: [
                                                      CupertinoActivityIndicator(
                                                        radius: 17,
                                                        animating: true,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Đang đăng xuất ...",
                                                          style: Subtitle1black,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          if (state is LogoutFailure) {
                                            Navigator.pop(context);
                                            Dialogs().showFailureAndRetryDialog(
                                                context: context,
                                                content: state.message,
                                                reTry: () {
                                                  Navigator.pop(context);
                                                  BlocProvider.of<LoginBloc>(
                                                          context)
                                                      .add(LogoutButtonPress());
                                                });
                                          }
                                          if (state is LogoutSuccess) {
                                            Navigator.pop(context);
                                            BlocProvider.of<AuthenticationBloc>(
                                                    context)
                                                .add(LoggedOut());
                                          }
                                        },
                                      ),
                                    ])),
                              ],
                            ),

                    ),
                  ),
                ));
  }
}

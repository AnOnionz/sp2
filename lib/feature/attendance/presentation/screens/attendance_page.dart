import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/map_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/img_button.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

import '../../../../di.dart';
import '../../../../no_internet_page.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _mapController = Completer();
  TextEditingController ctlMaNV = TextEditingController();
  NetworkInfo networkInfo = sl<NetworkInfo>();
  final picker = ImagePicker();
  bool isConnected = true;
  File _image;


  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void previewImage(File image) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PreviewImageDialog(
          textButton: 'Chụp lại',
          image: image,
          onTap: () {
            getImage();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(int.parse('${DateTime.now().hour}${DateTime.now().minute}'));
    return Scaffold(
        body: StreamBuilder<DataConnectionStatus>(
            stream: networkInfo.listener,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data == DataConnectionStatus.connected) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<MapBloc>(
                      create: (context) => sl<MapBloc>()..add(MapStarted()),
                    ),
                    BlocProvider<CheckAttendanceBloc>(
                      create: (context) =>
                          sl<CheckAttendanceBloc>()..add(CheckAttendance()),
                    ),
                    BlocProvider<AttendanceBloc>(
                      create: (context) => sl<AttendanceBloc>(),
                    ),
                  ],
                  child: BlocBuilder<CheckAttendanceBloc, CheckAttendanceState>(
                      builder: (context, state) {
                    if (state is CheckAttendanceNoInternet) {
                      return Builder(
                        builder: (context) => NoInternetPage(
                          retry: () {
                            BlocProvider.of<CheckAttendanceBloc>(context)
                                .add(CheckAttendance());
                          },
                        ),
                      );
                    }
                    return Stack(
                      children: <Widget>[
                        BlocBuilder<MapBloc, MapState>(
                          builder: (context, state) {
                            if (state is MapLoaded) {
                              return RepaintBoundary(
                                  child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(state.position.latitude,
                                      state.position.longitude),
                                  zoom: 18,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _mapController.complete(controller);
                                  controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: LatLng(
                                                  state.position.latitude,
                                                  state.position.longitude),
                                              zoom: 20)));
                                },
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                zoomControlsEnabled: false,
                              ));
                            }
                            if (state is MapFailed) {
                              return Container(
                                child: Column(
                                  children: [
                                    Icon(Icons.error_outline),
                                    Text("Tải map thất bại"),
                                    FlatButton(
                                      onPressed: () {
                                        sl<MapBloc>().add(MapStarted());
                                      },
                                      child: Text("Tải lại"),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              child: const Center(
                                child: CupertinoActivityIndicator(
                                  radius: 16,
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 130,
                            child: BlocListener<CheckAttendanceBloc,
                                    CheckAttendanceState>(
                                listener: (context, checkState) async {
                                  if(checkState is CheckAttendanceSuccess){
                                    final end = AuthenticationBloc.outlet.end !=null ? int.parse(AuthenticationBloc.outlet.end.toString().replaceAll(":", "").replaceAll('h', '').replaceAll('H', '')): 0;
                                    final now = int.parse('${DateTime.now().hour}${DateTime.now().minute}');
                                   if(now < end && sl<DashBoardLocalDataSource>().dataToday.checkIn)
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
                                                        '''Chưa hết thời gian làm việc
                                                      bạn có chắc muốn chấm công ra ?''',
                                                        style: Subtitle1black,
                                                      ),
                                                    ),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        child: Text("Đồng ý"),
                                                        onPressed:() {
                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                  }
                              if (checkState is CheckAttendanceFailure) {
                                Dialogs().showFailureAndRetryDialog(
                                    context: context,
                                    content: checkState.error,
                                    reTry: () {
                                      Navigator.pop(context);
                                      BlocProvider.of<CheckAttendanceBloc>(
                                              context)
                                          .add(CheckAttendance());
                                    });
                              }
                            }, child: BlocBuilder<CheckAttendanceBloc,
                                        CheckAttendanceState>(
                                    builder: (context, checkState) {
                              if (checkState is CheckAttendanceInitial) {
                                return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 9,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(height: 8),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Tọa độ: ',
                                                        style: norText,
                                                      ),
                                                      BlocBuilder<MapBloc,
                                                          MapState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is MapLoaded) {
                                                            return Text(
                                                              'Đã xác định',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xff205527),
                                                              ),
                                                            );
                                                          }
                                                          return Text(
                                                            "Đang định vị...",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ImageButton(
                                              color: Colors.grey,
                                              onTap: () {},
                                              image: null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 45,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ]);
                              }
                              if (checkState is CheckAttendanceSuccess) {
                                return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 9,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(height: 8),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Tọa độ: ',
                                                        style: norText,
                                                      ),
                                                      BlocBuilder<MapBloc,
                                                          MapState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is MapLoaded) {
                                                            return Text(
                                                              'Đã xác định',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xff205527),
                                                              ),
                                                            );
                                                          }
                                                          return Text(
                                                            "Đang định vị...",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Material(
                                                    color: Color(0xff205527)
                                                        .withOpacity(0.38),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _image == null
                                                            ? getImage()
                                                            : previewImage(
                                                                _image);
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      child: _image == null
                                                          ? Container(
                                                              width: 60,
                                                              height: 47,
                                                              color: checkState
                                                                          .type
                                                                      is CheckIn
                                                                  ? greenOpacityColor
                                                                  : redOpacityColor,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/camera.png",
                                                                color: Colors
                                                                    .black87,
                                                                width: 30,
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: Image.file(
                                                                  _image,
                                                                  width: 60,
                                                                  height: 47,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                    ))),
                                          ],
                                        ),
                                      ),
                                      BlocListener<AttendanceBloc,
                                          AttendanceState>(
                                        listener: (context, state) {
                                          if (state is AttendanceFailure) {
                                            Dialogs().showFailureAndRetryDialog(
                                              context: context,
                                              content: state.error,
                                              reTry: () {
                                                BlocProvider.of<
                                                    AttendanceBloc>(
                                                    context)
                                                    .add(Attendance(
                                                    type: checkState
                                                        .type.value,
                                                    position: MapBloc
                                                        .position,
                                                    img: _image));
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            );
                                          }
                                          if (state is AttendanceSuccess) {
                                            Dialogs().showSuccessDialog(
                                                content: "Chấm công thành công",
                                                context: context,
                                                onPress: () {
                                                  Navigator.pop(context);
                                                  sl<TabBloc>().add(
                                                      TabPressed(index: 0));
                                                });
                                          }
                                          if (state
                                              is AttendanceInventoryNullFailure) {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Yêu cầu thông tin tồn kho '),
                                                  content: Text(
                                                    state.message,
                                                    style: Subtitle1black,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      textStyle: TextStyle(
                                                          color: Colors.red),
                                                      child: Text('Đóng'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child:
                                                          Text('Nhập tồn kho'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/inventory');
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          if (state
                                              is AttendanceHighlightNullFailure) {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Yêu cầu thông tin cuối ngày'),
                                                  content: Text(
                                                    state.message,
                                                    style: Subtitle1black,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      textStyle: TextStyle(
                                                          color: Colors.red),
                                                      child: Text('Đóng'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child: Text(
                                                          'Nhập thông tin'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/highlight');
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: BlocBuilder<AttendanceBloc,
                                            AttendanceState>(
                                          builder: (context, state) {
                                            if (state is AttendanceLoading) {
                                              return Container(
                                                  height: 45,
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: checkState.type
                                                            is CheckIn
                                                        ? Color(0xFF008319)
                                                        : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      radius: 15,
                                                    ),
                                                  ));
                                            }
                                            return BlocBuilder<MapBloc,
                                                MapState>(
                                              builder:
                                                  (context, state) {
                                                if (state is MapLoaded) {
                                                  return Material(
                                                    color: checkState.type is CheckIn
                                                        ? Color(0xFF008319)
                                                        : Colors.red,
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                            FocusNode());
                                                        if (_image == null) {
                                                          await showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                              false,
                                                              builder: (BuildContext
                                                              context) {
                                                                return ZoomIn(
                                                                  delay: Duration(
                                                                      milliseconds:
                                                                      100),
                                                                  child:
                                                                  CupertinoAlertDialog(
                                                                    title: Text(
                                                                        "Hình ảnh trống"),
                                                                    content: Text(
                                                                      "Bạn phải chụp ảnh để tiếp tục chấm công",
                                                                      style:
                                                                      Subtitle1black,
                                                                    ),
                                                                    actions: [
                                                                      CupertinoDialogAction(
                                                                          isDefaultAction:
                                                                          true,
                                                                          textStyle: TextStyle(
                                                                              color: Colors
                                                                                  .red),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(
                                                                                context);
                                                                          },
                                                                          child: Text(
                                                                              "Đóng")),
                                                                      CupertinoDialogAction(
                                                                          isDefaultAction:
                                                                          true,
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(
                                                                                context);
                                                                            getImage();
                                                                          },
                                                                          child: Text(
                                                                            "Chụp hình",
                                                                          )),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                          return;
                                                        }
                                                        BlocProvider.of<
                                                            AttendanceBloc>(
                                                            context)
                                                            .add(
                                                            Attendance(
                                                                type: checkState
                                                                    .type.value,
                                                                position: MapBloc
                                                                    .position,
                                                                img: _image));
                                                      },
                                                      borderRadius:
                                                      BorderRadius.circular(5),
                                                      child: Container(
                                                        height: 45,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                5)),
                                                        child: Text(
                                                          checkState.type.name,
                                                          style: notiTitle,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Container(
                                                  height: 45,
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ]);
                              }
                              return Container();
                            })),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            child:
                            Text(MyPackageInfo.packageInfo.version)),
                      ],
                    );
                  }),
                );
              }
              if (snapshot.hasData &&
                  snapshot.data == DataConnectionStatus.disconnected) {
                return NoInternetPage();
              }
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                    animating: true,
                  ),
                ),
              );
            }));
  }
}

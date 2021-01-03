import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/map_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/img_button.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/tab_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/screens/home_page.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

import '../../../../di.dart';

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
  File _image;

  requestCamera() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      await Permission.camera.request();
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
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
    return StreamBuilder<DataConnectionStatus>(
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
              child: Scaffold(
                body: BlocBuilder<CheckAttendanceBloc, CheckAttendanceState>(
                  builder: (context, state) {
                    if (state is CheckAttendanceNoInternet) {
                      return Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: FlareActor("assets/images/no_internet.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: "init")),
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
                                      zoom: 19,
                                    ),
                                    onMapCreated: (
                                        GoogleMapController controller) {
                                      _mapController.complete(controller);
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
                            margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset:
                                  Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 130,
                            child: BlocListener<CheckAttendanceBloc,
                                CheckAttendanceState>(
                                listener: (context, checkState) {
                                  if (checkState is CheckAttendanceFailure) {
                                    Dialogs().showFailureDialog(
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
                                                            builder: (context,
                                                                state) {
                                                              if (state is MapLoaded) {
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
                                              borderRadius: BorderRadius
                                                  .circular(5),
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
                                                            builder: (context,
                                                                state) {
                                                              if (state is MapLoaded) {
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
                                                          onTap: () async {
                                                            await requestCamera();
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
                                                            Alignment.center,
                                                            child: Image.asset(
                                                              "assets/images/camera.png",
                                                              color:
                                                              Colors.black87,
                                                              width: 30,
                                                            ),
                                                          )
                                                              : ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                            child: Image.file(
                                                                _image,
                                                                width: 60,
                                                                height: 47,
                                                                fit:
                                                                BoxFit.cover),
                                                          ),
                                                        ))),
                                              ],
                                            ),
                                          ),
                                          BlocListener<
                                              AttendanceBloc,
                                              AttendanceState>(
                                            listener: (context, state) {
                                              if (state is AttendanceFailure) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return CupertinoAlertDialog(
                                                      title: Text('Thông báo'),
                                                      content: Text(
                                                        state.error,
                                                        style: Subtitle1black,
                                                      ),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          isDefaultAction: true,
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .red),
                                                          child: Text('Đóng'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context).pop();
                                                          },
                                                        ),
                                                        CupertinoDialogAction(
                                                          isDefaultAction: true,
                                                          child: Text(
                                                              'Thử lại'),
                                                          onPressed: () {
                                                            BlocProvider.of<
                                                                AttendanceBloc>(
                                                                context)
                                                                .add(Attendance(
                                                                type: checkState
                                                                    .type.value,
                                                                position: MapBloc
                                                                    .position,
                                                                img: _image));
                                                            Navigator.of(
                                                                context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              if (state is AttendanceSuccess) {
                                                Dialogs().showMessageDialog(
                                                    content: "Chấm công thành công",
                                                    context: context,
                                                    onPress: () {
                                                      Navigator.pop(context);
                                                      sl<TabBloc>().add(
                                                          TabPressed(
                                                              index: 0));
                                                    });
                                              }
                                              if (state is AttendanceHighlightNullFailure) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return CupertinoAlertDialog(
                                                      title: Text('Thông báo'),
                                                      content: Text(
                                                        state.message,
                                                        style: Subtitle1black,
                                                      ),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          isDefaultAction: true,
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .red),
                                                          child: Text('Đóng'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context).pop();
                                                          },
                                                        ),
                                                        CupertinoDialogAction(
                                                          isDefaultAction: true,
                                                          child: Text(
                                                              'Nhập thông tin'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context).pop();
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
                                                      alignment: Alignment
                                                          .center,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        checkState
                                                            .type is CheckIn
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
                                                return Material(
                                                  color: checkState
                                                      .type is CheckIn
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
                                                            barrierDismissible: false,
                                                            builder:
                                                                (
                                                                BuildContext context) {
                                                              return ZoomIn(
                                                                delay: Duration(
                                                                    milliseconds: 100),
                                                                child:
                                                                CupertinoAlertDialog(
                                                                  title:
                                                                  Text(
                                                                      "Thông báo"),
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
                                                                        onPressed: () {
                                                                          Navigator
                                                                              .pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            "Đóng")),
                                                                    CupertinoDialogAction(
                                                                        isDefaultAction:
                                                                        true,
                                                                        onPressed: () {
                                                                          Navigator
                                                                              .pop(
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
                                                          .add(Attendance(
                                                          type:
                                                          checkState.type.value,
                                                          position:
                                                          MapBloc.position,
                                                          img: _image));
                                                    },
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    child: Container(
                                                      height: 45,
                                                      width: double.infinity,
                                                      alignment: Alignment
                                                          .center,
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
                                              },
                                            ),
                                          ),
                                        ]);
                                  }
                                  return Container();
                                })),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            );
          }
          if (snapshot.hasData &&
              snapshot.data == DataConnectionStatus.disconnected) {
            return Center(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: FlareActor("assets/images/no_internet.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "init")),
            );
          }

          return Container(
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                animating: true,
              ),
            ),
          );
        });
  }
}

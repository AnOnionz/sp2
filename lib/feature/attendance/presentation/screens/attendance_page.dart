import 'dart:async';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/map_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';

import '../../../../di.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _mapController = Completer();
  TextEditingController ctlMaNV = TextEditingController();
  NetworkInfo networkInfo = sl<NetworkInfo>();
  final picker = ImagePicker();
  AttendanceType type = CheckOut();
  File _image;
 

  openSettingsMenu(settingsName) async {
    var resultSettingsOpening = false;
    try {
      resultSettingsOpening =
      await AccessSettingsMenu.openSettings(settingsType: settingsName);
    } catch (e) {
      resultSettingsOpening = false;
    }
  }
  requestCamera() async{
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
        if(snapshot.hasData && snapshot.data == DataConnectionStatus.connected) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AttendanceBloc>(
                create: (context) => sl<AttendanceBloc>(),
              ),
              BlocProvider<MapBloc>(
                create: (context) =>
                sl<MapBloc>()
                  ..add(MapStarted()),
              ),
            ],
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  BlocBuilder<MapBloc, MapState>(
                    builder: (context, state) {
                      if (state is MapLoaded) {
                        return RepaintBoundary(
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    state.position.latitude,
                                    state.position.longitude),
                                zoom: 19,
                              ),
                              onMapCreated: (GoogleMapController controller) {
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
                          child: CircularProgressIndicator(),
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          BlocBuilder<MapBloc, MapState>(
                                            builder: (context, state) {
                                              if (state is MapLoaded) {
                                                return Text(
                                                  'Đã xác định',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff205527),
                                                  ),
                                                );
                                              }
                                              return Text(
                                                "Đang định vị...",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontStyle: FontStyle.italic,
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
                                    color: Color(0xff205527).withOpacity(0.38),
                                    borderRadius: BorderRadius.circular(3),
                                    child: InkWell(
                                      onTap: () async {
                                        await requestCamera();
                                        _image == null
                                            ? getImage()
                                            : previewImage(_image);
                                      },
                                      borderRadius: BorderRadius.circular(3),
                                      child: _image == null
                                          ? Container(
                                        width: 60,
                                        height: 47,
                                        color: type is CheckIn ? greenOpacityColor : redOpacityColor ,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/images/camera.png",
                                          color: Colors.black87,
                                          width: 30,
                                        ),
                                      )
                                          : ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.file(_image,
                                            width: 60,
                                            height: 47,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          BlocListener(
                            cubit: sl<AttendanceBloc>(),
                            listener: (context, state) {
                              print(state);
                              if (state is AttendanceFailure) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Thông báo chấm công'),
                                      content: Text(state.error),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Đóng'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              if (state is AttendanceSuccess) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Thông báo chấm công'),
                                      content: Text(state.message),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Đóng'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Chấm công'),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            sl<AttendanceBloc>().add(
                                                CheckInOrOut(
                                                    type: type.value,
                                                    spId: state.attendanceEntity
                                                        .spID,
                                                    position: MapBloc.position,
                                                    img: _image));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              if (state is CheckInOrOutSuccess) {
                                setState(() {
                                  ctlMaNV.clear();
                                  _image = null;
                                });

                                Fluttertoast.showToast(
                                  msg: "Đã chấm công thành công.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                              if (state is CheckInOrOutFailure) {
                                Fluttertoast.showToast(
                                  msg: "Đã có lỗi xảy ra.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            },
                            child: BlocBuilder<MapBloc, MapState>(
                              builder: (context, state) {
                                if (state is MapLoaded) {
                                  return BlocBuilder(
                                    cubit: sl<AttendanceBloc>(),
                                    builder: (context, state) {
                                      if (state is AttendanceLoading ||
                                          state is CheckInOrOutLoading) {
                                        return Container(
                                          height: 45,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(0xff205527),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator()),
                                        );
                                      }
                                      return Material(
                                        color:
                                        type is CheckIn ? Color(0xFF008319) : Colors
                                            .red,
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          onTap: () {
                                            print(_image);
                                            if (_image == null) {
                                              return Scaffold.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Yêu cầu chụp hình để tiếp tục chấm công.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Hãy nhập đầy đủ dữ liệu.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(
                                              5),
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                            child: Text(
                                              type.name,
                                              style: notiTitle,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return Container(
                                  height: 45,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    type.name,
                                    style: notiTitle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if(snapshot.hasData && snapshot.data == DataConnectionStatus.disconnected) {
          openSettingsMenu('ACTION_WIRELESS_SETTINGS');
          return Center(
            child: Container(height: MediaQuery.of(context).size.height,
                child: FlareActor(
                    "assets/images/no_internet.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "init")),
          );

        }

        return Container();

      }
    );
  }
}

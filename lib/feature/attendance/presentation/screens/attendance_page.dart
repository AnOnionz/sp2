import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/text.dart';
import 'package:sp_2021/feature/attendance/domain/entities/attendance_type.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/blocs/map_bloc.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';

import '../../../../di.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  Completer<GoogleMapController> _controller = Completer();
  String maNV = '';
  TextEditingController ctlMaNV = TextEditingController();
  String radioItem;
  int id;
  File _image;
  final picker = ImagePicker();

  List<AttendanceType> rdList = [CheckIn(), CheckOut()];

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
    return MultiBlocProvider(
     providers: [
       BlocProvider<AttendanceBloc>(
         create: (context) => sl<AttendanceBloc>(),
       ),
       BlocProvider<MapBloc>(
         create: (context) => sl<MapBloc>()..add(MapStarted()),
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
                     target: LatLng(state.position.latitude, state.position.longitude),
                     zoom: 19,
                   ),
                   onMapCreated: (GoogleMapController controller) {
                     _controller.complete(controller);
                   },
                   myLocationEnabled: true,
                   myLocationButtonEnabled: true,
                   zoomControlsEnabled: false,
                 )
                 );
               }
               if(state is MapFailed){
                 return Container(
                   child: Column(
                     children: [
                       Icon(Icons.error_outline),
                       Text("Tải map thất bại"),
                       FlatButton(
                         onPressed: (){
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
               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
               padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(3),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3), // changes position of shadow
                   ),
                 ],
               ),
               height: 190,
               child: Column(
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       Text('Loại chấm công: ', style: norText),
                       Spacer(),
                       Container(
                         height: 20,
                         child: Wrap(
                           runSpacing: 70,
                           direction: Axis.vertical,
                           children: rdList.map((data) {
                             return Theme(
                               data: ThemeData(
                                 unselectedWidgetColor: Color(0xff205527),
                               ),
                               child: Row(
                                 children: <Widget>[
                                   SizedBox(
                                     height: 30,
                                     width: 30,
                                     child: Radio(
                                       value: data.index,
                                       groupValue: id,
                                       activeColor: Color(0xffFF2B00),
                                       onChanged: (val) {
                                         setState(() {
                                           radioItem = data.value;
                                           id = data.index;
                                         });
                                       },
                                     ),
                                   ),
                                   GestureDetector(
                                     onTap: () {
                                       setState(() {
                                         radioItem = data.value;
                                         id = data.index;
                                       });
                                     },
                                     child: Text(
                                       data.name,
                                       style: TextStyle(
                                         fontSize: 16,
                                         color: Color(0xff205527),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             );
                           }).toList(),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: 8),
                   Row(
                     children: <Widget>[
                       Text(
                         'Tọa độ: ',
                         style:norText,
                       ),
                       BlocBuilder<MapBloc, MapState>(
                         builder: (context, state) {
                           if (state is MapLoaded) {
                             return Text(
                               'Đã xác định vị trí',
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
                   SizedBox(height: 8),
                   Row(
                     children: <Widget>[
                       SizedBox(width: 7),
                       Material(
                         color: Color(0xff205527).withOpacity(0.38),
                         borderRadius: BorderRadius.circular(3),
                         child: InkWell(
                           onTap: () {
                             _image == null ? getImage() : previewImage(_image);
                           },
                           borderRadius: BorderRadius.circular(3),
                           child: _image == null
                               ? Container(
                             width: 60,
                             height: 47,
                             alignment: Alignment.center,
                             child: Image.asset(
                               "assets/images/camera.png",
                               color: Colors.black87,
                               width: 30,
                             ),
                           )
                               : ClipRRect(
                             borderRadius: BorderRadius.circular(5),
                             child: Image.file(_image, width: 60, height: 47, fit: BoxFit.cover),
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: 8),
                   //
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
                                     sl<AttendanceBloc>().add(CheckInOrOut(type: radioItem, spId: state.attendanceEntity.spID, position: MapBloc.position, img: _image));
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
                               if (state is AttendanceLoading || state is CheckInOrOutLoading) {
                                 return Container(
                                   height: 45,
                                   width: double.infinity,
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                     color:  Color(0xff205527),
                                     borderRadius: BorderRadius.circular(5),
                                   ),
                                   child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
                                 );
                               }
                               return Material(
                                 color: Color(0xff205527),
                                 borderRadius: BorderRadius.circular(5),
                                 child: InkWell(
                                   onTap: () {
                                     print(_image);

                                     if(_image == null){
                                       return Scaffold.of(context).showSnackBar(
                                         SnackBar(
                                           content: Text('Yêu cầu chụp hình để tiếp tục chấm công.'),
                                           backgroundColor: Colors.red,
                                         ),
                                       );
                                     }
                                     else if (radioItem != null && ctlMaNV.text.length != 0 && _image != null) {
                                       sl<AttendanceBloc>().add(CheckAttendance(type: radioItem, spCode: ctlMaNV.text));
                                     } else {
                                       Scaffold.of(context).showSnackBar(
                                         SnackBar(
                                           content: Text('Hãy nhập đầy đủ dữ liệu.'),
                                           backgroundColor: Colors.red,
                                         ),
                                       );
                                     }
                                   },
                                   borderRadius: BorderRadius.circular(5),
                                   child: Container(
                                     height: 45,
                                     width: double.infinity,
                                     alignment: Alignment.center,
                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                     child: Text(
                                       'Chấm công',
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
                             'Chấm công',
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
}

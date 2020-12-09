import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_2021/core/common/text.dart';

class Dialogs {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<void> showFailureDialog() async {
    return showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: AlertDialog(
              title: new Text("Thông báo"),
              content: new Text("Có lỗi xảy ra, vui lòng thử lại."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> showNoInternetDialog(VoidCallback retry) async {
    return showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return true;
            },
            child: AlertDialog(
              content: new Text("không có kết nối mạng",
                style: TextStyle(color: Colors.black, fontSize: 18),),
              actions: <Widget>[
                FlatButton(
                  child: new Text("HỦY"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: new Text("THỬ LẠI"),
                  onPressed: retry,
                ),
              ],
            ),
          );
        });
  }

  Future<void> showConfirmNotifyDialog(String content,
      String confirmText, VoidCallback confirm) async {
    return showDialog(
      context: navigatorKey.currentState.overlay.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: AlertDialog(
            content: Text(
              content, style: TextStyle(color: Colors.black, fontSize: 18),),
            actions: <Widget>[
              FlatButton(
                child: new Text("HỦY"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text(confirmText),
                onPressed: confirm,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showNotifyDialog(String content) async {
    return showDialog(
      context: navigatorKey.currentState.overlay.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(content),
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

  Future<void> showRequiredCheckInDialog(BuildContext context,
      VoidCallback checkIn) async {
    return showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              return false;
            },
            child: AlertDialog(
              title: const Text("Thông báo"),
              content: const Text("Cần phải chấm công để bắt đầu công việc"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'HỦY',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    'CHẤM CÔNG',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                  onPressed: checkIn,
                ),

              ],
            ),
          );
        });
  }

 Future<void> showProgressDialog(BlocBuilder widget,) async {
    return showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => true,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
//              child: Container(
//                height: 100,
//                width: 100,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
////                  SpinKitCircle(color: Colors.black54),
//                    CircularProgressIndicator(
//                      strokeWidth: 3,
//                      backgroundColor: Colors.white,
//                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF8330)),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Text(
//                      "Đang xử lý",
//                      style: TextStyle(color: Colors.black54),
//                    )
//                  ],
//                ),
//              ),
              child: widget,
            ),
          );
        });
  }

  Future<void> showBackHomeDialog(String content) async {
    return showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
              content: Container(
                height: 130,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông báo",
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      content,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("HỦY"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("ĐỒNG Ý"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          );
        });
  }
}
class CustomImageDialog extends StatefulWidget {
  final File image;
  final Function event;
  final String textButton;

  CustomImageDialog({@required this.image, this.event, @required this.textButton});

  @override
  _CustomImageDialogState createState() => _CustomImageDialogState();
}

class _CustomImageDialogState extends State<CustomImageDialog> {
  File get _image => widget.image;
  Function get _event => widget.event;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(5),
      children: <Widget>[
        Container(
          //          height: MediaQuery.of(context).size.height * 0.6,
          child: Image.file(
            _image,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          children: <Widget>[
            FlatButton(
              child: Text(
                widget.textButton,
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              onPressed: _event,
            ),
            Spacer(),
            FlatButton(
              child: Text(
                'Đóng',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class Dialogs {
  Future<void> showMessageDialog(
      {BuildContext context, String content,}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 100),
            child: CupertinoAlertDialog(
              title: Text("Thông báo"),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  content,
                  style: Subtitle1black,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("Đóng"),
                  onPressed:() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context);
                      },
                ),
              ],
            ),
          );
        });
  }
  Future<void> showSuccessDialog(
      {BuildContext context, String content, Function onPress}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 100),
            child: CupertinoAlertDialog(
              title: Container(
                height: 70,
                width: 70,
                child: FlareActor("assets/images/correct.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "go"),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  content,
                  style: Subtitle1black,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("Đóng"),
                  onPressed: onPress ??
                      () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context);
                      },
                ),
              ],
            ),
          );
        });
  }

  Future<void> showFailureDialog(
      {BuildContext context, String content, Function onPress}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 100),
            child: CupertinoAlertDialog(
              title: Container(
                height: 70,
                width: 70,
                child: FlareActor("assets/images/Error.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "go"),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  content,
                  style: Subtitle1black,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("Đóng"),
                  onPressed: onPress ??
                      () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context);
                      },
                ),
              ],
            ),
          );
        });
  }

  Future<void> showSavedToLocalDialog(
      {BuildContext context, String content}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 100),
            child: CupertinoAlertDialog(
              title: Container(
                height: 70,
                width: 70,
                child: FlareActor("assets/images/correct.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "go"),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  content,
                  style: Subtitle1black,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("Đóng"),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> showFailureAndRetryDialog(
      {BuildContext context, Function reTry, String content}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 100),
            child: CupertinoAlertDialog(
              title: Text("Thông báo"),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  content,
                  style: Subtitle1black,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  textStyle: TextStyle(color: Colors.red),
                  child: Text("Thử lại"),
                  onPressed: reTry,
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Đóng"),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
  Future<void> showRequireAttendanceDialog(
      {BuildContext context, Function attendance, String content}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: ZoomIn(
            duration: const Duration(milliseconds: 100),
            child: CupertinoAlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Yêu cầu chấm công"),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                 content,
                  style: Subtitle1black,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Thoát")),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: attendance,
                    child: Text("Chấm công")),
              ],
            ),
          ),
        ));
  }

  Future<void> showRequireSyncDialog(
      {BuildContext context, String content}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: ZoomIn(
              duration: const Duration(milliseconds: 100),
              child: CupertinoAlertDialog(
                title: Text("Yêu cầu đồng bộ"),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    content,
                    style: Subtitle1black,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      textStyle: TextStyle(color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("Thoát")),
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, '/sync_data');
                      },
                      child: Text("Đồng bộ")),
                ],
              ),
            )));
  }
  Future<void> showDoSaveDialog(
      {BuildContext context}) async {
    return showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text("Thông tin chưa lưu"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Thông tin chưa được lưu, bạn chắc chắn muốn thoát ?",
                style: Subtitle1black,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                textStyle: TextStyle(color: Colors.red),
                child: Text("Không"),
                onPressed: () {
                  Navigator.pop(context);
                  },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Có"),
                onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
              ),
            ],
          );
        });
  }

}

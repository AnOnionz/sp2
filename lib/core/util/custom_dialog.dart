import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Dialogs {
  Future<void> showMessageDialog({BuildContext context, String content, Function onPress}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Thông báo"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content, style: Subtitle1black,),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Đóng"),
                onPressed: onPress ?? () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  Future<void> showSavedToLocalDialog({BuildContext context, String content}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Thông báo"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content,  style: Subtitle1black,),
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
          );
        });
  }


  Future<void> showFailureDialog(
      {BuildContext context, Function reTry, String content}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Thông báo"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content,  style: Subtitle1black,),
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
          );
        });
  }
}

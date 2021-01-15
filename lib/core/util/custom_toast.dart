import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {

 static showNewMessageToast() {
  return Fluttertoast.showToast(
    msg: "⋆ Bạn nhận được 1 thông báo mới ⋆",
   toastLength: Toast.LENGTH_LONG,
   gravity: ToastGravity.TOP,
   timeInSecForIosWeb: 1,
   backgroundColor: Colors.black54,
   textColor: Colors.white,
   fontSize: 16.0,
  );

}
}
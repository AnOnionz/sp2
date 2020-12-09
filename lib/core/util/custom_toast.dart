import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
static showCheckInSuccessToast() {
  return Fluttertoast.showToast(
    msg: "Đã chấm công thành công.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

static showUpdateSuccessToast() {
  return Fluttertoast.showToast(
    msg: "Đã cập nhật thành công.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

static showSaveSuccessToast() {
  return Fluttertoast.showToast(
    msg: "Đã lưu thành công.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

static showRemoveSuccessToast() {
  return Fluttertoast.showToast(
    msg: "Đã xóa thành công.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

static showFailureToast() {
  return Fluttertoast.showToast(
    msg: "Đã có lỗi xảy ra.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

static showAddSuccessToast() {
  return Fluttertoast.showToast(
    msg: "Đã thêm thành công.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

static showMissingTextField(BuildContext context) {
  return Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Hãy nhập đầy đủ thông tin.'),
      backgroundColor: Colors.red,
    ),
  );
}

static showWrongFormatTextField(BuildContext context) {
  return Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Sai định dạng giá trị diện tích.'),
      backgroundColor: Colors.red,
    ),
  );
}
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
class NextButton extends StatelessWidget {
  final VoidCallback onPress;

  const NextButton({Key key, this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPress,
      padding: const EdgeInsets.only(bottom: 5, left: 50, right: 50),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34.0)
      ),
      elevation: 20,
      child: Text(
        "TIẾP TỤC",
        style: TextStyle(color: Color(0X0FF00551E), fontSize: 40, fontFamily: 'UTMBebas'),
      ),
    );
  }
}

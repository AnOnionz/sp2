import 'package:flutter/material.dart';
class BarChart extends StatelessWidget {
  final int value;
  const BarChart({Key key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double a = (MediaQuery.of(context).size.height/4/3 ) / 112.5;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(value.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        Container(
          height: value < 300 ? a * value : 300 *a,
          width: 50,
          decoration: BoxDecoration(color: Colors.blue),
        ),
      ],
    );
  }
}
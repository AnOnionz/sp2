import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final int kpi;
  const Board({Key key, this.kpi}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LineBoard(color: Colors.white,),
          LineBoard(color: Colors.white,),
          LineBoard(color: Colors.red, num: kpi,),
          LineBoard(color: Colors.white,),
        ],
      ),
    );
  }
}
class LineBoard extends StatelessWidget{
  final int num;
  final Color color;

  const LineBoard({Key key, this.num, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        num != null? Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            num.toString(),
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ):Container(),
        Expanded(
          child: Container(
            height: num!= null ? 4 :2,
            decoration: BoxDecoration(
              color: color,
            ),
          ),
        ),
      ],
    );
  }

}

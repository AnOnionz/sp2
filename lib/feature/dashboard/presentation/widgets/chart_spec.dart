import 'package:flutter/material.dart';

class ChartSpec extends StatelessWidget {
  final int kpi;
  final int sell;

  const ChartSpec({Key key, this.kpi, this.sell}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(width: 1, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text("Số lượng bia đã bán: ${sell.toString()} thùng",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 4,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Số lượng bia cần bán: ${kpi.toString()} thùng",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

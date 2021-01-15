import 'package:flutter/material.dart';

class ChartSpec extends StatelessWidget {
  const ChartSpec({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: MediaQuery.of(context).size.width/12),
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
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Số lượng bia đã bán",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
//                Padding(
//                  padding: const EdgeInsets.only(left: 5),
//                  child: Text("Số lượng bia đã bán: ${sell.toString()} thùng",
//                      style: TextStyle(color: Colors.white, fontSize: 14)),
//                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 5,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "KPI cần đạt được",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.only(left: 5),
//                  child: Text(
//                    "Số lượng bia cần bán: ${kpi.toString()} thùng",
//                    style: TextStyle(color: Colors.white, fontSize: 15),
//                  ),
//                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

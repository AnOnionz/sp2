import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/chart_spec.dart';

import 'barchart.dart';
import 'board_chart.dart';

class ChartKPI extends StatelessWidget {
  final int kpi;
  final int sell;

  const ChartKPI({Key key, this.kpi, this.sell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 20, right: 20, bottom: 50),
      child: Column(
        children: [
          MyChart(kpi: kpi, sell: sell,),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              "biểu đồ KPI",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontStyle: FontStyle.italic),
            ),
          ),
          ChartSpec(
            kpi: kpi,
            sell: sell,
          ),
        ],
      ),
    );
  }
}

class MyChart extends StatelessWidget {
  final int kpi;
  final int sell;

  const MyChart({Key key, this.kpi, this.sell}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Stack(
        children: [
          Board(
            kpi: kpi,
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width/5,
            child: BarChart(
              value: sell,
            ),
          ),
        ],
      ),
    );
  }
}
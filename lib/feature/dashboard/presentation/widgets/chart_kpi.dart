import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/kpi_entity.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/chart_spec.dart';

import 'barchart.dart';
import 'board_chart.dart';

class ChartKPI extends StatelessWidget {
  final KpiEntity kpiEntity;

  const ChartKPI({Key key, this.kpiEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, right: 20, bottom: 50),
      child: Column(
        children: [
          MyChart(kpiEntity: kpiEntity,),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Tổng số ngày làm việc ${kpiEntity.dayOf}/17",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic, fontSize: 17),
            ),
          ),
          ChartSpec(
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
              children: [
                TextSpan(
                  text: '''*Ghi chú: trung bình mỗi ngày cần bán''', style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ''' 15 ''', style: TextStyle(color: Colors.yellow, fontSize: 17, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                TextSpan(text: '''thùng để đạt kpi''', style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),),
              ]
            ),),
          ),
        ],
      ),

    );
  }
}

class MyChart extends StatelessWidget {
  final KpiEntity kpiEntity;

  const MyChart({Key key, this.kpiEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Stack(
        children: [
          Board(
            kpi: 225,
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 5,
            child: BarChart(
              value: kpiEntity.sell,
            ),
          ),
        ],
      ),
    );
  }
}
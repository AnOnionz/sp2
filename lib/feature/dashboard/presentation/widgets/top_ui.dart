import 'package:flutter/material.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/kpi_entity.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/chart_kpi.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/outlet_info.dart';

import '../../../../di.dart';

class TopUi extends StatelessWidget {
  const TopUi();
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: OutletInfo()),
          Expanded(child: ChartKPI(kpiEntity: KpiEntity(dayOf: 15, sell: 180),),)

//          Expanded(child: StreamBuilder<Object>(
//            initialData: KpiEntity(dayOf: 1, sell: 1),
//            stream: sl<DashBoardRemoteDataSource>().kpiStream,
//            builder: (context, snapshot) {
//              final kpi = snapshot.data;
//              Stream.periodic(const Duration(seconds: 5000)).listen((event) {
//                sl<DashBoardRemoteDataSource>().fetchKpi(kpi);
//              });
//              return ChartKPI(kpiEntity: kpi,);
//            }
//          )),
        ],
      ),
    );
  }
}

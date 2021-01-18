import 'package:flutter/material.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
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
         // Expanded(child: ChartKPI(kpiEntity: KpiEntity(dayOf: 15, sell: 180),),)
          Expanded(child: StreamBuilder<Object>(
            initialData: sl<DashBoardLocalDataSource>().fetchKpi(),
            stream: sl<DashBoardLocalDataSource>().kpiStream,
            builder: (context, snapshot) {
              final kpi = snapshot.data;
              return ChartKPI(kpiEntity: kpi,);
            }
          )),
        ],
      ),
    );
  }
}

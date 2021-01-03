import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/chart_kpi.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/outlet_info.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

class TopUi extends StatelessWidget {
  const TopUi();
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: OutletInfo(outlet:AuthenticationBloc.outlet,)),
          Expanded(child: const ChartKPI(kpi: 15, sell: 100,)),
        ],
      ),
    );
  }
}

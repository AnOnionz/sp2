
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/feature_grid.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/top_ui.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';


class HomePage extends StatelessWidget {
  final LoginEntity loginEntity;

  const HomePage({Key key, this.loginEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 3,child: const TopUi()),
              Expanded(flex: 2, child: const FeatureGrid()),
            ]
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            child:
            Text(MyPackageInfo.packageInfo.version)),
      ],
    );
  }


}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/feature_grid.dart';
import 'package:sp_2021/feature/dashboard/presentation/widgets/top_ui.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';


class HomePage extends StatelessWidget {
  final LoginEntity loginEntity;

  const HomePage({Key key, this.loginEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 3,child: const TopUi()),
          Expanded(flex: 2, child: const FeatureGrid()),
        ]
      ),
    );
  }


}


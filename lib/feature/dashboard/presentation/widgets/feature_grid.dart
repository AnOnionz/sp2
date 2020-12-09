import 'package:flutter/material.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/features.dart';

import 'feature_button.dart';
class FeatureGrid extends StatelessWidget {
  const FeatureGrid();
  @override
  Widget build(BuildContext context) {
    final List items = <Feature>[LuckyWheel(), SalePrice(), RivalSalePrice(), Inventory(), Highlight(), ProductRequirement()];
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,),
      child: GridView(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 5/4),
        children: items.map((feature) => FeatureButton(feature: feature)).toList(),
      ),
    );
  }
}

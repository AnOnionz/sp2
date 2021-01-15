import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/features.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

import '../../../../di.dart';

class FeatureButton extends StatelessWidget {
  final Feature feature;

  const FeatureButton({Key key, this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      padding: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, feature.nextRoute);
          },
          borderRadius: BorderRadius.circular(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 9,
                margin: EdgeInsets.only(bottom: 12),
                child: feature.image,
              ),
              FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  feature.label,
                  textAlign: TextAlign.center,
                  style: featureText,
                ),
              ),
            ],
          )),
    );
  }
}

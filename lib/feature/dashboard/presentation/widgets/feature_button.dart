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
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 9,
                    margin: EdgeInsets.only(bottom: 12),
                    child: feature.image,
                  ),
                  feature is SyncData ? StreamBuilder(
                      initialData:sl<SyncLocalDataSource>().getSync().nonSynchronized + sl<SyncLocalDataSource>().getSync().imageNonSynchronized ,
                      stream: sl<SyncLocalDataSource>().syncStream,
                      builder: (context, snapshot) => snapshot.data > 0
                          ? Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(3),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 15,
                          ),
                          child: Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                          : Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            constraints: BoxConstraints(
                              minWidth: 13,
                              minHeight: 13,
                            ),
                          ))) : Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        constraints: BoxConstraints(
                          minWidth: 13,
                          minHeight: 13,
                        ),
                      )),
                ],
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

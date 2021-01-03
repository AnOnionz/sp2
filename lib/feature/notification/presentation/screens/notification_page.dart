import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';

import '../../../../di.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                child: const Text(
                  'THÔNG BÁO',
                  style: header,
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<FcmEntity>(NOTIFICATION_BOX).listenable(),
                  builder: (context, Box<FcmEntity> box, _) {
                    if (box.values.isEmpty)
                      return Center(
                        child: Text("Bạn chưa nhận được thông báo nào", style: Subtitle1white,),
                      );
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        itemCount: box.values.length,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemBuilder: (context, index) {
                          FcmEntity fcm = box.getAt(index);
                          return Container(
                            decoration: BoxDecoration(
                              color: fcm.isClick ? Colors.white70 : Colors.white,
                            ),
                            child: Row(
                              children: [Text(fcm.title??"title"), Text(fcm.body??"body")],
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}

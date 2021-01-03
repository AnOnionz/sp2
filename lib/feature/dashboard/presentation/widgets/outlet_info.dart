import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

class OutletInfo extends StatelessWidget {
  final LoginEntity outlet;

  const OutletInfo({Key key, this.outlet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:20, left: 20),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(outlet.name, style: infoOutletHeader,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Outlet code: ${outlet.id}", style: infoOutletSubtext,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Địa chỉ: ${outlet.address}", style: infoOutletSubtext,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Tên SR: ${outlet.spName}", style: infoOutletSubtext),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("SĐT SR: ${outlet.spSDT}", style: infoOutletSubtext),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Thời gian thực hiện: ${outlet.time}", style: infoOutletSubtext),
            ),
          ],
        ),
      ),
    );
  }
}

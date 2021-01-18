import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';


class OutletInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final outlet = AuthenticationBloc.outlet;
    return outlet != null ? Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
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
              child: Text(
                "Outlet code : ${outlet.id}", style: infoOutletSubtext,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Địa chỉ : ${outlet.address}", style: infoOutletSubtext,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Tên SP : ${outlet.spName}", style: infoOutletSubtext),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("SĐT SP : ${outlet.spSDT}", style: infoOutletSubtext),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Thời gian thực hiện : ${outlet.begin} - ${outlet.end}",
                  style: infoOutletSubtext),
            ),
          ],
        ),
      ),
    ): Container(child: Center(child: CupertinoActivityIndicator(radius: 20,animating: true,),),);
  }
}

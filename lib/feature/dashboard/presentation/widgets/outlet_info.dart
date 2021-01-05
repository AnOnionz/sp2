import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

import '../../../../di.dart';

class OutletInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: LoginEntity(),
      future: sl<AuthenticationBloc>().getUser(),
      builder: (context, AsyncSnapshot<LoginEntity> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Padding(
            padding: const EdgeInsets.only(top:20, left: 20),
            child: Center(child: CupertinoActivityIndicator(radius: 20,),),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top:20, left: 20),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.data.name, style: infoOutletHeader,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Outlet code: ${snapshot.data.id}", style: infoOutletSubtext,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Địa chỉ: ${snapshot.data.address}", style: infoOutletSubtext,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Tên SR: ${snapshot.data.spName}", style: infoOutletSubtext),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("SĐT SR: ${snapshot.data.spSDT}", style: infoOutletSubtext),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Thời gian thực hiện: ${snapshot.data.time}", style: infoOutletSubtext),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

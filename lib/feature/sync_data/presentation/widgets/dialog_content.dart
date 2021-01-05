import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/sync_data/presentation/blocs/sync_data_bloc.dart';

class DialogContent extends StatelessWidget {
  final SyncDataBloc bloc;

  const DialogContent({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: bloc,
      builder: (context, state) {
        if (state is SyncDataLoading) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.tealAccent.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Đang đồng bộ",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
        if (state is SyncDataSuccess) {
          return AlertDialog(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Center(
              child: Text(
                "Thông báo",
                style: Subtitle1black,
              ),
            ),
            content: Text(
            "Dữ liệu đã đồng bộ thành công",
            style: Subtitle1black,
          ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Thoát",
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                      )),
                ],
              ),
            ],
          );
        }
        if (state is SyncDataFailure) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title:Center(
              child: Text(
                "Thông báo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            content: Text(
              "Đã xảy ra lỗi",
              style: Subtitle1black,
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Thoát",
                      style: TextStyle(color: Colors.blue, fontSize: 17))),
            ],);
        }
        return Container();
      },
    );
  }
}

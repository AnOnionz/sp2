import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_local_datasource.dart';
import 'package:sp_2021/feature/sync_data/domain/entities/sync_entity.dart';
import 'package:sp_2021/feature/sync_data/presentation/blocs/sync_data_bloc.dart';

import '../../../../di.dart';

class SyncDataPage extends StatefulWidget {
  @override
  _SyncDataPageState createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  SyncLocalDataSource local;
  SyncDataBloc bloc;
  SyncEntity sync;

  @override
  void initState() {
    super.initState();
    local = sl<SyncLocalDataSource>();
    bloc = sl<SyncDataBloc>();
    sync = local.getSync();
    print(sync);
    
  }

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
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                    child: const Text(
                      'Đồng bộ dữ liệu',
                      style: header,
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    child:
                    Text(MyPackageInfo.packageInfo.version)),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1, child: Text('Dữ liệu:', style: notiTitle)),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 35,
                            animationDuration: 1000,
                            percent: sync.nonSynchronized > 0 ? sync.nonSynchronized / (sync.nonSynchronized + sync.synchronized) : 0.0,
                            center: Text('${sync.nonSynchronized}/${sync.synchronized + sync.nonSynchronized}', style: norText),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: const Color(0xffFF2B00),
                            backgroundColor: Colors.white,
                            // backgroundColor: const Color(0xff205527),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text('Hình ảnh:', style: notiTitle)),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 35,
                            animationDuration: 1000,
                            percent: sync.imageNonSynchronized > 0 ? sync.imageNonSynchronized / (sync.imageNonSynchronized + sync.imageSynchronized) : 0.0,
                            center: Text('${sync.imageNonSynchronized}/${sync.imageSynchronized + sync.imageNonSynchronized}', style: norText),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: const Color(0xffFF2B00),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: const EdgeInsets.only(top: 60, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10,
                          children: [
                            Container(
                                height: 20,
                                width: 20,
                                color: const Color(0xffFF2B00)),
                            Text('chưa đồng bộ', style: notiTitle)
                          ],
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: [
                            Container(
                                height: 20, width: 20, color: Colors.white),
                            Text('đã đồng bộ', style: notiTitle)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                      '* Chú thích: dữ liệu chưa đồng bộ trên tổng số dữ liệu trong ca làm việc',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            BlocListener(
              cubit: bloc,
              listener: (context, state) {
                if(state is SyncDataCloseDialog){
                  Navigator.of(context).pop(true);
                }
                if(state is SyncDataLoading){
                  showDialog(context: context,
                  barrierDismissible: false,
                  builder: (_) => CupertinoAlertDialog(
                    content: Column(
                      children: [
                        CupertinoActivityIndicator(radius: 20, animating: true,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Đang đồng bộ...",style: Subtitle1black,),
                        ),
                      ],
                    ),
                  ));
                }
                if(state is SyncDataSuccess){
                  Navigator.pop(context);
                  setState(() {
                    sync = local.getSync();
                  });
                  Dialogs().showSuccessDialog(context: context, content: "Đồng bộ hoàn tất");
                }
                if(state is SyncDataFailure){
                  Navigator.pop(context);
                  setState(() {
                    sync = local.getSync();
                  });
                  Dialogs().showFailureDialog(context: context, content: '''Đồng bộ Thất bại
                                                                            ${state.message} ''');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Material(
                  color: sync.nonSynchronized > 0 || sync.imageNonSynchronized > 0 ? const Color(0xffFF2B00) : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  child: InkWell(
                    onTap: () {
                      if(sync.nonSynchronized > 0 || sync.imageNonSynchronized > 0){
                        bloc.add(SyncStart());
                      }
                    },
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.center,
                      child: Text(
                        'Đồng bộ',
                        style: TextStyle(
                          fontSize: 16,
                          color: sync.nonSynchronized > 0 || sync.imageNonSynchronized > 0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

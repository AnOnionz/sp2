import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sp_2021/core/common/text_styles.dart';

class SyncDataPage extends StatelessWidget {
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
                  'Đồng bộ dữ liệu',
                  style: header,
                ),
              ),
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
                            animationDuration: 2000,
                            percent: 0.3,
                            center: Text('10', style: norText),
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
                            animationDuration: 2000,
                            percent: .4,
                            center: Text('10', style: norText),
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Material(
                color: const Color(0xffFF2B00),
                borderRadius: BorderRadius.all(Radius.circular(3)),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.center,
                    child: Text(
                      'Đồng bộ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

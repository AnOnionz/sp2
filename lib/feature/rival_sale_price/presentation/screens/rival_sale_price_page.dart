import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/widgets/rival_sale_price_ui.dart';

import '../../../../di.dart';
class RivalSalePricePage extends StatefulWidget {
  final List<RivalProductEntity> products;

  const RivalSalePricePage({Key key, this.products}) : super(key: key);

  @override
  _RivalSalePricePageState createState() => _RivalSalePricePageState();
}

class _RivalSalePricePageState extends State<RivalSalePricePage> {
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  List<RivalProductEntity> rivals;
  @override
  void initState() {
    rivals = local.fetchRivalProduct();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'CẬP NHẬT GIÁ BIA ĐỐI THỦ',
                                style: header,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 60,
                                height: 30,
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(5),
                                    child: Center(
                                      child: Text(
                                        'LƯU',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff008319),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                RivalSalePriceUi(rivals: rivals,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
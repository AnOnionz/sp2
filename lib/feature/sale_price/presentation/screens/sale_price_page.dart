import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/sale_price/presentation/widgets/sale_price_ui.dart';

import '../../../../di.dart';
class SalePricePage extends StatefulWidget {
    SalePricePage({Key key}) : super(key: key);

  @override
  _SalePricePageState createState() => _SalePricePageState();
}

class _SalePricePageState extends State<SalePricePage> {
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  List<ProductEntity> products;
  @override
  void initState() {
    products = local.fetchProduct();
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 60),
                        Text(
                          'CẬP NHẬT GIÁ BIA BÁN',
                          style: header,
                        ),
                        Container(
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
                      ]
                  ),
                ),
                SalePriceUi(products: products,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
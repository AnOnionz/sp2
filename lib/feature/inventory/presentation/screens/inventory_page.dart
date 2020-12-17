import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/inventory/presentation/widgets/inventory_ui.dart';

import '../../../../di.dart';

class InventoryPage extends StatefulWidget {
  final List<ProductEntity> products;

  const InventoryPage({Key key, this.products}) : super(key: key);
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

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
                        'TỒN KHO',
                        style: header,
                      ),
                     Container(
                            width: 60,
                                height:30,
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {
                                    },
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
                InventoryUi(products: products ,)
                    ],
                  ),
                ),
  ),
      ),
    );
  }
}


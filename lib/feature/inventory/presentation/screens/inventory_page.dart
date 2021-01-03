import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/inventory/presentation/blocs/inventory_bloc.dart';
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
  int page = 0;
  PageController _controller;
  @override
  void initState() {
    _controller = PageController(
      initialPage: page,
    );
    products = local.fetchProduct();
    print(products);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocProvider<InventoryBloc>(
            create: (context) => sl<InventoryBloc>(),
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
                  child: BlocListener<InventoryBloc, InventoryState>(
                    listener: (context, state) {
                      if (state is InventoryUpdated) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo'),
                              content: Text("Dữ liệu cập nhật thành công"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Đóng'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (state is InventoryUpdateFailure) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo'),
                              content: Text("Dữ liệu đang chờ đồng bộ"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Đóng'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Builder(
                      builder: (context) => Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
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
                                  height: 30,
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        BlocProvider.of<InventoryBloc>(context)
                                            .add(InventoryUpdate(
                                                products: products));
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
                              ]),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [

                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _controller.animateToPage(0,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve:
                                                Curves.fastOutSlowIn);
                                      },
                                      child: Container(
                                        color: page == 0
                                            ? Colors.black54
                                            : Colors.black12,
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            "Đầu ca",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _controller.animateToPage(1,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve:
                                                Curves.fastOutSlowIn);
                                      },
                                      child: Container(
                                        height: 50,
                                        color: page == 0
                                            ? Colors.black12
                                            : Colors.black54,
                                        child: Center(
                                            child: Text(
                                          "Cuối ca",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: PageView(
                                  controller: _controller,
                                  onPageChanged: (int value) {
                                    setState(() {
                                      page = value;
                                    });
                                  },
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    Column(
                                      children: [
                                        InventoryUi(
                                          products: products,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InventoryUi(
                                          products: products,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            )));
  }
}

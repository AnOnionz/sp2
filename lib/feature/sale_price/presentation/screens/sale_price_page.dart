import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/sale_price/presentation/blocs/sale_price_bloc.dart';
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
    print(products);
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
            child: BlocProvider(
              create: (_) => sl<SalePriceBloc>(),
              child: BlocListener<SalePriceBloc, SalePriceState>(
                listener: (context, state) {
                  if(state is SalePriceCloseDialog){
                    Navigator.pop(context);
                  }
                  if(state is SalePriceLoading){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: CupertinoActivityIndicator(
                              radius: 20,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is SalePriceUpdated) {
                    Navigator.pop(context);
                    Dialogs().showMessageDialog(context: context, content: "Giá bia bán đã cập nhật thành công");
                  }
                  if (state is SalePriceCached) {
                    Navigator.pop(context);
                    Dialogs().showMessageDialog(context: context, content: "Giá bia bán đã được lưu lại");
                  }
                  if (state is SalePriceUpdateFailure) {
                    Navigator.pop(context);
                    Dialogs().showSavedToLocalDialog(content: state.message, context: context);
                  }
                },
                child: Builder(
                  builder: (context) => Column(
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
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      BlocProvider.of<SalePriceBloc>(context)
                                          .add(SalePriceUpdate(
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
                      SalePriceUi(
                        products: products,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

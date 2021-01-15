import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
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
    final dataToday = local.dataToday;
    final productsData = local.fetchProduct();
    products = dataToday.salePrice == null ? List.castFrom(productsData.map((e) => e.copyWith(price: 0)).toList()):
    List.castFrom(productsData.map((e) => e.copyWith(price: dataToday.salePrice.firstWhere((element) => element['sku_id'] == e.productId)['price'])).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final data = local.dataToday.salePrice;
        final salePrice = data!=null ? data.map((e) => e['price']).toList() : List.generate(products.length, (index) => 0);
        if(salePrice.join('') != products.map((e) => e.price).toList().join('')){
          Dialogs().showDoSaveDialog(context: context);
          return false;
        }
        return true;
      },
      child: GestureDetector(
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
                        Dialogs().showSuccessDialog(context: context, content: "Giá bia bán đã cập nhật thành công");
                      }
                      if (state is SalePriceCached) {
                        Navigator.pop(context);
                        Dialogs().showSavedToLocalDialog(context: context, content: "Giá bia bán đã được lưu lại");
                      }
                      if (state is SalePriceUpdateFailure) {
                        Navigator.pop(context);
                        Dialogs().showSavedToLocalDialog(content: state.message, context: context);
                      }
                    },
                    child: Builder(
                      builder: (context) => Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
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
                                              if (products.every(
                                                      (element) => element.price == 0)) {
                                                Scaffold.of(context)
                                                    .removeCurrentSnackBar();
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Giá bia bán phải khác 0', style: Subtitle1white,),
                                                  backgroundColor: Colors.red,
                                                ));
                                                return ;
                                              }
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
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child:
                                  Text(MyPackageInfo.packageInfo.version)),
                            ],
                          ),
                          SalePriceUi(
                            products: products,
                            reFresh: (){
                              sl<DashboardBloc>().add(SaveServerDataToLocalData());
                              setState(() {
                                final dataToday = local.dataToday;
                                final productsData = local.fetchProduct();
                                products = dataToday.salePrice == null ? List.castFrom(productsData.map((e) => e.copyWith(price: 0)).toList()):
                                List.castFrom(productsData.map((e) => e.copyWith(price: dataToday.salePrice.firstWhere((element) => element['sku_id'] == e.productId)['price'])).toList());
                              });
                            },
                          ),
                        ],
                      ),
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

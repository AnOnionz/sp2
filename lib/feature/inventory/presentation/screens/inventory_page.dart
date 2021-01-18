import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/inventory/presentation/blocs/inventory_bloc.dart';
import 'package:sp_2021/feature/inventory/presentation/widgets/inventory_ui.dart';

import '../../../../di.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  List<ProductEntity> inProducts;
  List<ProductEntity> outProducts;
  int page = 0;
  PageController _controller;


  @override
  void initState() {
    _controller = PageController(
      initialPage: page,
    );
    _initData();
    super.initState();
  }
  _initData(){
    final dataToday = local.dataToday;
    final products = local.fetchProduct();
    inProducts = dataToday.inventoryEntity == null ? List.castFrom(products.map((e) => e.copyWith(count: 0)).toList()) :
    List.castFrom(products.map((e) => e.copyWith(count: dataToday.inventoryEntity.inInventory.firstWhere((element) => element['sku_id'] == e.productId)['qty'])).toList());
    outProducts = dataToday.inventoryEntity == null ? List.castFrom(products.map((e) => e.copyWith(count: 0)).toList()) :
    List.castFrom(products.map((e) => e.copyWith(count: dataToday.inventoryEntity.outInventory.firstWhere((element) => element['sku_id'] == e.productId)['qty'])).toList());
    print(inProducts);
    print(outProducts);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final data = local.dataToday.inventoryEntity;
        final iniv = data!=null ? data.inInventory.map((e) => e['qty']).toList() : List.generate(inProducts.length, (index) => 0);
        final outiv = data!=null ? data.outInventory.map((e) => e['qty']).toList() : List.generate(outProducts.length, (index) => 0);
        if(iniv.join('') != inProducts.map((e) => e.count).toList().join('') || outiv.join('') != outProducts.map((e) => e.count).toList().join('') ){
          Dialogs().showDoSaveDialog(context: context);
          return false;
        }
        return true;
      },
      child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BlocProvider<InventoryBloc>(
                create: (context) => sl<InventoryBloc>()..add(InventoryStart()),
                child: Scaffold(
                  key: _scaffoldKey,
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
                          if(state is InventoryLoading){
                            showDialog(
                              context: context,
                              builder: (_) {
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
                          if(state is InventoryCloseDialog){
                            Navigator.pop(context);
                          }
                          if (state is InventoryUpdated) {
                            Navigator.pop(context);
                            Dialogs().showSuccessDialog(context: context, content: state.message);
                          }
                          if(state is InventoryCached){
                            Navigator.pop(context);
                            Dialogs().showSavedToLocalDialog(context: context, content: "Tồn kho đã được lưu lại");
                          }
                          if (state is InventoryFailure) {
                            Navigator.pop(context);
                            Dialogs().showFailureAndRetryDialog(context: context, content: state.message, reTry: (){
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
                              if (inProducts.every(
                                      (element) => element.count == 0)) {
                                Scaffold.of(context)
                                    .removeCurrentSnackBar();
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Thông tin tồn đầu phải khác 0', style: Subtitle1white,),
                                  backgroundColor: Colors.red,
                                ));
                                return ;
                              }
                              final inInventory = inProducts
                                  .map((e) => {
                                "sku_id": e.productId,
                                "qty": e.count
                              })
                                  .toList();
                              final outInventory = outProducts
                                  .map((e) => {
                                "sku_id": e.productId,
                                "qty": e.count
                              })
                                  .toList();
                              BlocProvider.of<InventoryBloc>(context)
                                  .add(InventoryUpdate(
                                  inventory: InventoryEntity(
                                      inInventory: inInventory,
                                      outInventory:
                                      outInventory)));
                            });
                          }
                        },
                        child: Builder(
                          builder: (context) => Column(children: <Widget>[
                            Stack(
                              children: [
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
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                if (inProducts.every(
                                                    (element) => element.count == 0)) {
                                                  Scaffold.of(context)
                                                      .removeCurrentSnackBar();
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Thông tin tồn đầu phải khác 0', style: Subtitle1white,),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                  return ;
                                                }
                                                final inInventory = inProducts
                                                    .map((e) => {
                                                          "sku_id": e.productId,
                                                          "qty": e.count
                                                        })
                                                    .toList();
                                                final outInventory = outProducts
                                                    .map((e) => {
                                                          "sku_id": e.productId,
                                                          "qty": e.count
                                                        })
                                                    .toList();
                                                BlocProvider.of<InventoryBloc>(context)
                                                    .add(InventoryUpdate(
                                                        inventory: InventoryEntity(
                                                            inInventory: inInventory,
                                                            outInventory:
                                                                outInventory)));
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
                                                curve: Curves.fastOutSlowIn);
                                          },
                                          child: Container(
                                            color: page == 0
                                                ? Colors.black54
                                                : Colors.black12,
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                "Tồn đầu",
                                                style: TextStyle(
                                                    color: page == 0 ? Colors.blueAccent : Colors.white ,
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
                                                curve: Curves.fastOutSlowIn);
                                          },
                                          child: Container(
                                            height: 50,
                                            color: page == 0
                                                ? Colors.black12
                                                : Colors.black54,
                                            child: Center(
                                                child: Text(
                                              "Tồn cuối",
                                              style: TextStyle(
                                                  color: page == 0 ? Colors.white : Colors.blueAccent,
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
                                              products: inProducts,
                                              reFresh: (){
                                                sl<DashboardBloc>().add(SaveServerDataToLocalData());
                                                setState(() {
                                                  _initData();
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            InventoryUi(
                                              products: outProducts,
                                              reFresh: (){
                                                sl<DashboardBloc>().add(SaveServerDataToLocalData());
                                                setState(() {
                                                  _initData();
                                                });
                                              },
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
                ))
      ),
    );
  }

}

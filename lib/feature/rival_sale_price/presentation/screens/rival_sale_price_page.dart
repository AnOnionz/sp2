import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/blocs/rival_sale_price_bloc.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/widgets/rival_dialog.dart';
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
  List<RivalProductEntity> allRival;
  bool isDialog ;

  @override
  void initState() {
    isDialog = isDialog ?? false;
    allRival = local.fetchRivalProduct();
    rivals = _fetchRivals();

   super.initState();
  }
  List<RivalProductEntity> _fetchRivals(){
    final dataToday = local.dataToday;
    final rivalsData = local.fetchAvailableRivalProduct();
    return dataToday.rivalSalePrice == null
        ? List.castFrom(rivalsData.map((e) => e.copyWith(price: 0)).toList())
        : List.castFrom(rivalsData
        .map((e) => e.copyWith(
        price: dataToday.rivalSalePrice.firstWhere(
                (element) => element['sku_id'] == e.id, orElse: ()=>{"sku_id": e.id, "price": 0})['price']))
        .toList());
  }
  RivalProductEntity _getRival(String name){
    return allRival.firstWhere((element) => element.name == name);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final data = local.dataToday.rivalSalePrice;
        final rivalSalePrice = data!=null ? data.map((e) => e['price']).toList() : List.generate(rivals.length, (index) => 0);
        if(rivalSalePrice.join('') != rivals.map((e) => e.price).toList().join('')){
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
                  create: (_) => sl<RivalSalePriceBloc>(),
                  child: BlocListener<RivalSalePriceBloc, RivalSalePriceState>(
                    listener: (context, state) {
                      if (state is RivalSalePriceCloseDialog) {
                        Navigator.pop(context);
                      }
                      if (state is RivalSalePriceLoading) {
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
                      if (state is RivalSalePriceUpdated) {
                        Navigator.pop(context);
                        Dialogs().showSuccessDialog(
                            context: context,
                            content: "Giá bia đối thủ đã cập nhật thành công");
                      }
                      if (state is RivalSalePriceCached) {
                        Navigator.pop(context);
                        Dialogs().showSavedToLocalDialog(
                            context: context,
                            content: "Giá bia đối thủ đã được lưu lại");
                      }
                      if (state is RivalSalePriceFailure) {
                        Navigator.pop(context);
                        Dialogs().showSavedToLocalDialog(
                            context: context, content: state.message);
                      }
                    },
                    child: Builder(
                      builder: (context) => Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
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
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (rivals.every(
                                                      (element) => element.price == 0)) {
                                                Scaffold.of(context)
                                                    .removeCurrentSnackBar();
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Vui lòng nhập giá bia của một đối thủ', style: Subtitle1white,),
                                                  backgroundColor: Colors.red,
                                                ));
                                                return ;
                                              }
                                              BlocProvider.of<RivalSalePriceBloc>(
                                                      context)
                                                  .add(RivalSalePriceUpdate(
                                                      rivals: rivals));
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
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child:
                                  Text(MyPackageInfo.packageInfo.version)),
                            ],
                          ),
                          RivalSalePriceUi(
                            rivals: rivals,
                            reFresh: (){
                              sl<DashboardBloc>().add(SaveServerDataToLocalData());
                              setState(() {
                                allRival = local.fetchRivalProduct();
                                rivals = _fetchRivals();
                              });
                            },
                          ),
                          rivals.length > 0 ? InkWell(
                            onTap: () {
                              setState(() {
                                isDialog = true;
                              });
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => FadeInUp(
                                  duration: Duration(milliseconds: 600),
                                  child: RivalDialog(
                                    addRival: (String name, bool add){
                                      setState(() {
                                       if(add){
                                         rivals.add(_getRival(name));
                                       }else{
                                         rivals.remove(_getRival(name));
                                       }
                                      });
                                    },
                                    close: (){
                                      setState(() {
                                        isDialog = false;
                                      });
                                    },
                                  ),
                                )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15, top: 15),
                              child: Container(
                                width: 200 ,
                                height: 45,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Thêm đối thủ".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff008319),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ): Container(),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/blocs/rival_sale_price_bloc.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/widgets/rival_sale_price_ui.dart';

import '../../../../di.dart';

class RivalSalePricePage extends StatefulWidget {
  final List<RivalProductEntity> products;

  const RivalSalePricePage({Key key, this.products}) : super(key: key);

  @override
  _RivalSalePricePageState createState() => _RivalSalePricePageState();
}

class _RivalSalePricePageState extends State<RivalSalePricePage> {
  List<RivalProductEntity> rivals;
  @override
  void initState() {
    rivals = sl<DashBoardLocalDataSource>().fetchRivalProduct();
    print(rivals);
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
              create: (_) => sl<RivalSalePriceBloc>(),
              child: BlocListener<RivalSalePriceBloc, RivalSalePriceState>(
                listener: (context, state) {
                  if(state is RivalSalePriceCloseDialog){
                    Navigator.pop(context);
                  }
                  if(state is RivalSalePriceLoading){
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
                    Dialogs().showMessageDialog(context: context, content: "Giá bia đối thủ đã cập nhật thành công");
                  }
                  if (state is RivalSalePriceCached) {
                    Navigator.pop(context);
                    Dialogs().showMessageDialog(context: context, content: "Giá bia đối thủ đã được lưu lại");
                  }
                  if(state is RivalSalePriceFailure){
                    Navigator.pop(context);
                    Dialogs().showSavedToLocalDialog(context: context, content: state.message);
                  }
                },
                child: Builder(
                  builder: (context) => Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(children: <Widget>[
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
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        BlocProvider.of<RivalSalePriceBloc>(context)
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
                            ]),
                          ],
                        ),
                      ),
                      RivalSalePriceUi(
                        rivals: rivals,
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

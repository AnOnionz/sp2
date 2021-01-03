import 'dart:core';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/send_requirement/presentation/blocs/send_requirement_bloc.dart';
import 'package:sp_2021/feature/send_requirement/presentation/widgets/require_form.dart';
import 'package:sp_2021/feature/send_requirement/presentation/widgets/require_gifts.dart';
import 'package:sp_2021/feature/send_requirement/presentation/widgets/require_products.dart';

import '../../../../di.dart';

class ProductRequirementPage extends StatefulWidget {
  @override
  _ProductRequirementPageState createState() => _ProductRequirementPageState();
}

class _ProductRequirementPageState extends State<ProductRequirementPage> {
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  List<ProductEntity> products;
  List<GiftEntity> gifts;
  int page = 0;
  PageController _controller ;

  @override
  void initState() {
    _controller = PageController(
    initialPage: page,
    );
    products = local.fetchProduct();
    gifts = local.fetchGift();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocProvider(
            create: (_)=> sl<SendRequirementBloc>(),
            child: BlocConsumer<SendRequirementBloc, SendRequirementState>(
              listener: (context, state) {
                if(state is SendRequirementLoading){
                  showDialog(context: context,
                      barrierDismissible: false,
                      builder: (_) => CupertinoAlertDialog(
                        content: Column(
                          children: [
                            CupertinoActivityIndicator(radius: 20, animating: true,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Đang gửi yêu cầu", style: Subtitle1black,),
                            ),
                          ],
                        ),
                      ));
                }
                if(state is SendRequirementSuccess){
                  Navigator.pop(context);
                  Dialogs().showMessageDialog(context: context, content: "Yêu cầu đã được gửi");
                }
                if(state is SendRequirementCached){
                  Navigator.pop(context);
                  Dialogs().showMessageDialog(context: context, content: "Yêu cầu chưa được gửi");
                }
                if(state is SendRequirementFailure){
                  Navigator.pop(context);
                  Dialogs().showMessageDialog(context: context, content: state.message);
                }
              },
              builder: (context, state) => Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 35, 0, 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'YÊU CẦU HÀNG',
                            style: header,
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
                                onTap: (){
                                  _controller.animateToPage(0, duration:  Duration(milliseconds: 1000), curve: Curves.fastLinearToSlowEaseIn);
                                },
                                child: Container(
                                  color: page == 1 ? Colors.black54 : Colors.black12,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Quà",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
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
                                onTap: (){
                                  _controller.animateToPage(1, duration: Duration(milliseconds: 1000), curve: Curves.fastLinearToSlowEaseIn);
                                },
                                child: Container(
                                  height: 50,
                                  color: page == 1 ? Colors.black12 : Colors.black54,
                                  child: Center(
                                      child: Text(
                                    "Bia",
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 20),
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
                                  RequireGifts(
                                    gifts: gifts,
                                  ),
                                  RequireForm(
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  RequireProducts(
                                    products: products,
                                  ),
                                  RequireForm(
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

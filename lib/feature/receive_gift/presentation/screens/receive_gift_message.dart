import 'dart:io';
import 'dart:math';
import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';

class ReceiveGiftMessagePage extends StatefulWidget {
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<File> takeProductImg;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final int giftAt;

  const ReceiveGiftMessagePage({Key key, this.customer, this.products, this.takeProductImg, this.giftReceive, this.giftReceived, this.giftAt,}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _ReceiveGiftMessageState();
}

class _ReceiveGiftMessageState extends State<ReceiveGiftMessagePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gift = widget.giftReceived[widget.giftAt];
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(alignment: Alignment.center ,child: Image.asset(gift.asset)),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  AssetImage("assets/images/background_congratulation.gif"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "CHÚC MỪNG BẠN ĐÃ NHẬN ĐUỢC 1 ${gift.name.toUpperCase()}",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        )),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      "Hoang Vu",
                                      style: Subtitle1white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      "0905004002",
                                      style: Subtitle1white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            BlocProvider.of<ReceiveGiftBloc>(context).add(GiftNext(customer: widget.customer, products: widget.products, takeProductImg: widget.takeProductImg, giftReceived: widget.giftReceived, giftReceive: widget.giftReceive, giftAt: widget.giftAt+1));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Color(0XFFFF0000),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Tiếp tục",
                                  style: Subtitle1white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

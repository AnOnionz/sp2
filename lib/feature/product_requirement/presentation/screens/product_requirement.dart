import 'dart:core';
import 'package:flutter/material.dart';
import 'package:sp_2021/app/entities/gift_entity.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/core/common/text.dart';

class ProductRequirementPage extends StatefulWidget {
  @override
  _ProductRequirementPageState createState() => _ProductRequirementPageState();
}

class _ProductRequirementPageState extends State<ProductRequirementPage> {
  List<GiftEntity> gifts = [
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Nen(name: "Nen", amountCurrent: 10),
    Voucher(name: "Voucher", amountCurrent: 2),
  ];
  List<ProductEntity> products = [
    Heneiken(productName: "Heneiken", count: 100)
  ];
  bool isShowQua = true;

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
          child: Column(
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
                            onTap: () {
                              setState(() {
                                isShowQua = !isShowQua;
                              });
                            },
                            child: Container(
                              color:
                                  isShowQua ? Colors.black54 : Colors.black12,
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
                            onTap: () {
                              setState(() {
                                isShowQua = !isShowQua;
                              });
                            },
                            child: Container(
                              height: 50,
                              color:
                                  isShowQua ? Colors.black12 : Colors.black54,
                              child: Center(
                                  child: Text(
                                "Bia",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                    isShowQua ? buildGifts(gifts) : buildProducts(products),
                    InkWell(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 5),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(child: Text("Yêu Cầu", style: norText,),),
                        ),
                      ),
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

  Expanded buildGifts(List<GiftEntity> list) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: list.length,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.6),
            height: 1,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    list[index].name,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Số lượng tồn:',
                        style: normalText,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        list[index].amountCurrent.toString(),
                        style: normalText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildProducts(List<ProductEntity> list) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: list.length,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.6),
            height: 1,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    list[index].productName,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Số lượng tồn:',
                        style: normalText,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        list[index].count.toString(),
                        style: normalText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

class BuildListProduct extends StatelessWidget {
  final bool is18;
  final List<ProductEntity> products;
  final FocusNode nextFocus;
  final BuildContext pContext;


  const BuildListProduct({Key key, this.is18, this.products, this.nextFocus, this.pContext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: products.map((e) {
        int index = products.indexOf(e);
        return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text('${e.productName}', style: e is StrongBowPack6 ? formTextSB : formText)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 43,
                              child: InputField(
                                isSBP6: e is StrongBowPack6,
                                enable: is18,
                                thisFocus: e.focus,
                                nextFocus: index == products.length - 1
                                    ? nextFocus
                                    : products[index + 1].focus,
                                controller: e.controller,
                                onChanged: (value){
                                  if(e is StrongBowPack6 && e.controller.text.isNotEmpty && int.parse(e.controller.text) ~/1 > 3){
                                    showDialog(
                                        context: pContext,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: ZoomIn(
                                              duration: const Duration(milliseconds: 100),
                                              child: CupertinoAlertDialog(
                                                title: Text("Thông báo"),
                                                content: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '''Số lượng lốc 6 lon Strongbow tối đa là 3
                                                      Mỗi 4 lốc Strongbow được quy đổi thành 
                                                      1 STRONGBOW THÙNG 
                                                         Vui lòng quy đổi và nhập lại vào 
                                                         ô STRONGBOW THÙNG phía trên.''',
                                                    style: Subtitle1black,
                                                  ),
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: Text("Đã hiểu"),
                                                    onPressed:() {
                                                      Navigator.pop(pContext);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                    FocusScope.of(pContext).requestFocus(e.focus);
                                  }
                                  e.buyQty = e.controller.text.isEmpty ? 0 : int.parse(e.controller.text) ~/1;
                                },
                                textAlign: TextAlign.left,
                                subText: e is StrongBowPack6 ? "Lốc" : "Thùng",
                                action: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                inputType: TextInputType.number,
                                inputFormatter: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  e is StrongBowPack6 ? LengthLimitingTextInputFormatter(1) :LengthLimitingTextInputFormatter(5) ,
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      e is StrongBowPack6 ? Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            'Số lượng tối đa cho phép : 3 ', style: TextStyle(color: Colors.cyanAccent, fontStyle: FontStyle.italic, fontSize: 15),
                          )
                      ): Container()
                    ],
                  ),
                ),
              ],
            ),
        );
      }).toList()
    );
  }
}

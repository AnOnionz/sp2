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

  const BuildListProduct({Key key, this.is18, this.products, this.nextFocus}) : super(key: key);
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
              Expanded(child: Text('${e.productName}', style: formText)),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 43,
                        child: InputField(
                          enable: is18,
                          thisFocus: e.focus,
                          nextFocus: index == products.length - 1
                              ? nextFocus
                              : products[index + 1].focus,
                          controller: e.controller..addListener(() {
                            e.buyQty = e.controller.text.isEmpty ? 0 : int.parse(e.controller.text) ~/1;
                          }),
                          textAlign: TextAlign.left,
                          subText: "Thùng",
                          action: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          inputType: TextInputType.number,
                          inputFormatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

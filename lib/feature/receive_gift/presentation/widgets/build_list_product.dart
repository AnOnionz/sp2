import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

class BuildListProduct extends StatelessWidget {
  final List<ProductEntity> products;
  final FocusNode nextFocus;

  const BuildListProduct({Key key, this.products, this.nextFocus}) : super(key: key);
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
                        height: 40,
                        child: InputField(
                          thisFocus: e.focus,
                          nextFocus: index == products.length - 1
                              ? nextFocus
                              : products[index + 1].focus,
                          controller: e.controller,
                          textAlign: TextAlign.left,
                          hint: '',
                          action: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          inputType: TextInputType.number,
                          inputFormatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
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

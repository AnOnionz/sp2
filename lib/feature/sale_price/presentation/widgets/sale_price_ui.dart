import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';

import '../../../../di.dart';

class SalePriceUi extends StatelessWidget {
  final List<ProductEntity> products;
  final VoidCallback reFresh;

  const SalePriceUi({Key key, this.products, this.reFresh}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Expanded(
            child: products.length > 0  ? ListView.separated(
              itemCount: products.length,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.6),
                height: 1,
              ),
              itemBuilder: (context, index) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: CachedNetworkImage(
                        placeholderFadeInDuration: Duration(milliseconds: 300),
                        imageUrl: products[index].imgUrl,
                        height: 90,
                        width: 90,
                        placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.image_outlined, color: Colors.white70, size: 60,),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      products[index].productName.toUpperCase(),
                      style: formText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 43,
                      child: TextFormField(
                        focusNode:  products[index].focus,
                        textInputAction: index == products.length - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        textAlign: TextAlign.center,
                        autofocus: false,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(index == products.length - 1
                              ? null
                              :  products[index + 1].focus);
                        },
                        controller: products[index].priceController..value = TextEditingValue(text: NumberFormat.currency(symbol: '', decimalDigits: 0).format(products[index].price))..selection = TextSelection.collapsed(offset: products[index].priceController.text.length),
                        onChanged: (value){
                          final text = products[index].priceController.text.isEmpty ? 0 : int.parse(products[index].priceController.text.replaceAll(",", ""))~/1;
                          if(text != products[index].price){
                            products[index].price = text;
                            //onChange();
                          }
                        },
                        style: textInput,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          ThousandsFormatter(),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          suffixText: 'VNĐ/thùng',
                          suffixStyle: TextStyle(color: Colors.black, fontSize: 17),
                          contentPadding: const EdgeInsets.only(left: 15, right: 15),
                          filled: true,
                          fillColor: Colors.white ,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffeaeaea)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Color(0xffeaeaea)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Color(0xffeaeaea)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gapPadding: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: FlareActor("assets/images/no_available.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "Untitled"),
              ),
              Text("Danh sách sản phẩm trống", style: Subtitle1white,),
              RaisedButton(onPressed: (){
                reFresh();
              }, child: Text("Tải lại",style: TextStyle(color: greenColor),), elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),

            ],
            ),
          );
  }
}

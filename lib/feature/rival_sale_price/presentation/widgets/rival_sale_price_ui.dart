import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';

class RivalSalePriceUi extends StatelessWidget {
  final List<RivalProductEntity> rivals;
  final VoidCallback reFresh;

  const RivalSalePriceUi({Key key, this.rivals,this.reFresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: rivals.length > 0 ? ListView.separated(
              itemCount: rivals.length,
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
                        imageUrl: rivals[index].imgUrl,
                        height: 90,
                        width: 90,
                        placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                        errorWidget: (context, url, error) => Image.asset("assets/images/beer.png", height: 40, width: 40,),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                        rivals[index].name.toUpperCase(),
                      style: formText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 43,
                      child: TextFormField(
                        focusNode:  rivals[index].focus,
                        textInputAction: index == rivals.length - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        textAlign: TextAlign.center,
                        autofocus: false,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(index == rivals.length - 1
                              ? null
                              :  rivals[index + 1].focus);
                        },
                        controller: rivals[index].priceController..value = TextEditingValue(text: NumberFormat.currency(symbol: '', decimalDigits: 0).format(rivals[index].price))..selection = TextSelection.collapsed(offset: rivals[index].priceController.text.length),
                        onChanged: (value){
                          final text = rivals[index].priceController.text.isEmpty ? 0 : int.parse(rivals[index].priceController.text.replaceAll(",", ""))~/1;
                          if(text != rivals[index].price){
                            rivals[index].price = text;
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
                      )
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
                Text("Danh sách bia đối thủ trống", style: Subtitle1white,),
                RaisedButton(onPressed: (){
                  reFresh();
                }, child: Text("Tải lại",style: TextStyle(color: greenColor),), elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
              ],
            ),
          );
  }
}

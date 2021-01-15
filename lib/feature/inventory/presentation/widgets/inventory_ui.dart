import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

@immutable
class InventoryUi extends StatelessWidget {
  final List<ProductEntity> products;
  final VoidCallback reFresh;

  InventoryUi({Key key, this.products, this.reFresh}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: products.length > 0 ? GridView.count(
                    physics: BouncingScrollPhysics(),
                    childAspectRatio: 0.75,
                    crossAxisCount: 3,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    padding: const EdgeInsets.only(bottom: 20),
                    children: products.map((e) {
                      index += 1;
                      return Container(
                        padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                             CachedNetworkImage(
                              imageUrl: e.imgUrl,
                              height: 90,
                              width: 90,
                              placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                               errorWidget: (context, url, error) => Icon(Icons.image_outlined, color: Colors.teal, size: 60,),
                            ),
                             SizedBox(height: 5),
                            Text(
                              e.productName.toUpperCase(),
                              style: productName,
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                'Số lượng (${e is StrongBowPack6 ? 'lốc': 'thùng'})',
                                style: productUnit,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height: 35,
                              child: TextFormField(
                                focusNode: e.focus,
                                controller: e.countController..addListener(() {
                                  e.count = e.countController.text == null || e.countController.text == '' ? 0 : int.parse(e.countController.text)~/1;
                                }),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: productCount,
                                textInputAction:index == products.length ? TextInputAction.done: TextInputAction.next,
                                inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), FilteringTextInputFormatter.digitsOnly,FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xff008319).withOpacity(0.13),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                  errorStyle: TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                    height: 0,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff008319)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff008319)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ):Column(
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
                      },  child: Text("Tải lại",style: TextStyle(color: greenColor),), elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

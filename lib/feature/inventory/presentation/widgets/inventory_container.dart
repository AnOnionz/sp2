import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

class InventoryContainer extends StatefulWidget {
  final ProductEntity product;

 const InventoryContainer({Key key, this.product}) : super(key: key);

  @override
  _InventoryContainerState createState() => _InventoryContainerState();
}

class _InventoryContainerState extends State<InventoryContainer> {
  TextEditingController textCtrl;

  @override
  void initState() {
    super.initState();
    textCtrl = widget.product.controller;
  }

  Widget build(BuildContext context) {
    textCtrl.text = widget.product.count.toString();
    return RepaintBoundary(
      child: Container(
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
              imageUrl: widget.product.imgUrl,
              height: 90,
              width: 90,
              placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
              errorWidget: (context, url, error) => Icon(Icons.image_outlined, color: Colors.teal, size: 60,),
            ),
            SizedBox(height: 5),
            Text(
             widget.product.productName.toUpperCase(),
              style: productName,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                'Số lượng (${widget.product is StrongBowPack6 ? 'lốc': 'thùng'})',
                style: productUnit,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 35,
              child: TextField(
                focusNode: widget.product.focus,
                controller: textCtrl,
                onChanged: (value){
                  widget.product.count = textCtrl.text == null || textCtrl.text == '' ? 0 : int.parse(textCtrl.text)~/1;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: productCount,
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
      ),
    );
  }
}

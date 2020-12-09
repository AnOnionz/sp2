import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/core/common/text.dart';
import 'package:sp_2021/core/util/FutureImage.dart';

class InventoryPage extends StatefulWidget {
  final List<ProductEntity> products;

  const InventoryPage({Key key, this.products}) : super(key: key);
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 60),
                      Text(
                        'TỒN KHO',
                        style: header,
                      ),
                     Container(
                            width: 60,
                                height: 27,
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Center(
                                      child: Text(
                                        'LƯU',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff008319),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ]
                       ),
                        ),
                buildLoaded(widget.products),
                    ],
                  ),
                ),
  ),
      ),
    );
  }

  Expanded buildLoaded(List<ProductEntity> list) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              physics: BouncingScrollPhysics(),
              childAspectRatio: 0.60,
              crossAxisCount: 3,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              padding: const EdgeInsets.only(bottom: 20),
              children: list.map((e) {
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
                      FutureImage(image: "Heineken_Silver.png", height: 150,),
//                      CachedNetworkImage(
//                        imageUrl: e.imgUrl,
//                        height: 100,
//                        width: 100,
//                        placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CircularProgressIndicator())),
//                        errorWidget: (context, url, error) => Icon(Icons.error),
//                      ),
                      // SizedBox(height: 20),
                      Text(
                        e.productName.toUpperCase(),
                        style: productName,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Số lượng',
                        style: productUnit,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 30,
                        child: TextFormField(
                          controller: e.controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: productCount,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
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
            ),
          ),
        ],
      ),
    );
  }
}


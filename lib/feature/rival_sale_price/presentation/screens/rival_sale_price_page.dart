import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/core/common/text.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/core/util/FutureImage.dart';
class RivalSalePricePage extends StatefulWidget {
  final List<RivalProductEntity> products;

  const RivalSalePricePage({Key key, this.products}) : super(key: key);

  @override
  _RivalSalePricePageState createState() => _RivalSalePricePageState();
}

class _RivalSalePricePageState extends State<RivalSalePricePage> {
  bool isBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isBottomSheet ? Navigator.of(context).pop() :FocusScope.of(context).requestFocus(FocusNode());
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'CẬP NHẬT GIÁ BIA ĐỐI THỦ',
                                style: header,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 60,
                                height: 27,
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(5),
                                    child: Center(
                                      child: Text(
                                        'LƯU',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff008319),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
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

  Expanded buildLoaded(List<RivalProductEntity> list) {
    return Expanded(
      child: ListView.separated(
        itemCount: list.length,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.6),height: 1,),
        itemBuilder:(context, index) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                child: index %2 ==0 ? FutureImage(image: "tiger.png", height: 90 ,) : FutureImage(image: "Heineken_Silver.png", height: 90 ,),
              ),
            ),
//            CachedNetworkImage(
//              imageUrl: list[index].imgUrl,
//              height: 100,
//              width: 100,
//              placeholder: (context, url) =>
//                  SizedBox(height: 20,
//                      width: 20,
//                      child: Center(
//                          child: CircularProgressIndicator())),
//              errorWidget: (context, url, error) => Icon(Icons.error),
//            ),
            // SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Text(
                list[index].name.toUpperCase(),
                style: formText,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
                child: InputField(
                controller: list[index].controller,
                textCapitalization: TextCapitalization.characters,
                action:index == list.length-1 ? TextInputAction.done: TextInputAction.next,
                inputType: TextInputType.number,
                textAlign: TextAlign.center,
                  inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
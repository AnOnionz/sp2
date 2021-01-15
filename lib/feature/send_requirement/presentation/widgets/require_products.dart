import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';

import '../../../../di.dart';

class RequireProducts extends StatelessWidget {
  final List<ProductEntity> products;
  final VoidCallback reFresh;

  const RequireProducts({Key key, this.products, this.reFresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: products.length > 0 ? ListView.separated(
          itemCount: products.length,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.6),
            height: 1,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child:  CachedNetworkImage(
                    placeholderFadeInDuration: Duration(milliseconds: 300),
                    imageUrl: products[index].imgUrl,
                    height: 80,
                    width: 80,
                    placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.image_outlined, color: Colors.white70, size: 60,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(products[index].productName, style: Subtitle1white,),
                ),
              ],
            ),
          ),
        ): Center(
          child: Column(
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
            Text("Danh sách trống", style: Subtitle1white,),
            RaisedButton(onPressed: (){
              reFresh();
            },child: Text("Tải lại",style: TextStyle(color: greenColor),), elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
          ],
        ),),
      ),
    );
  }
}

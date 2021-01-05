import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

class RequireProducts extends StatelessWidget {
  final List<ProductEntity> products;

  const RequireProducts({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(products[index].productName, style: Subtitle1white,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

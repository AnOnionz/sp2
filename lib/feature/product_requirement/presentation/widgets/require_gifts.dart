import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';

class RequireGifts extends StatelessWidget {
  final List<GiftEntity> gifts;

  const RequireGifts({Key key, this.gifts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: gifts.length,
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
                    imageUrl: gifts[index].image,
                    height: 100,
                    width: 100,
                    placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(gifts[index].name, style: Subtitle1white,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

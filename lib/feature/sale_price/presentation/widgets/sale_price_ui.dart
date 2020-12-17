import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

class SalePriceUi extends StatelessWidget {
  final List<ProductEntity> products;

  const SalePriceUi({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: ListView.separated(
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
                        height: 100,
                        width: 100,
                        placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                      child: InputField(
                        thisFocus: products[index].focus,
                        nextFocus: index == products.length - 1
                            ? null
                            :  products[index + 1].focus,
                        controller:products[index].priceController,
                        textCapitalization: TextCapitalization.characters,
                        action: index == products.length - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        inputType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        inputFormatter: <TextInputFormatter>[
                          ThousandsFormatter()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

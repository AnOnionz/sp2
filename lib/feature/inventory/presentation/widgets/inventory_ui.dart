import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/inventory/presentation/widgets/inventory_container.dart';

@immutable
class InventoryUi extends StatefulWidget {
  final List<ProductEntity> products;
  final VoidCallback reFresh;

  const InventoryUi({Key key, this.products, this.reFresh}) : super(key: key);

  @override
  _InventoryUiState createState() => _InventoryUiState();
}

class _InventoryUiState extends State<InventoryUi> with AutomaticKeepAliveClientMixin<InventoryUi> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child:widget.products.length > 0 ? GridView.count(
                    physics: BouncingScrollPhysics(),
                    childAspectRatio: 0.75,
                    crossAxisCount: 3,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    padding: const EdgeInsets.only(bottom: 20),
                    children: widget.products.map((e) {
                      return InventoryContainer(product: e,);
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
                        widget.reFresh();
                      },  child: Text("Tải lại",style: TextStyle(color: greenColor),), elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override

  bool get wantKeepAlive => true;
}

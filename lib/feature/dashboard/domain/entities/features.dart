import 'package:flutter/material.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';

class Feature {

  final Image image;
  final String label;
  final String nextRoute;

   const Feature({this.image, this.label, this.nextRoute});

}
class LuckyWheel extends Feature {
  LuckyWheel() : super (image: Image.asset('assets/images/lottery.png', excludeFromSemantics: true,), label: "QUAY QUÀ", nextRoute: '/receive_gift');
}
class SalePrice extends Feature {
  SalePrice() : super (image: Image.asset('assets/images/sale.png', excludeFromSemantics: true,), label: "GIÁ BIA BÁN",nextRoute: '/sale_price');
}
class RivalSalePrice extends Feature {
  RivalSalePrice() : super (image: Image.asset('assets/images/competition.png', excludeFromSemantics: true,), label: "GIÁ BIA ĐỐI THỦ", nextRoute: '/rival_sale');
}
class Inventory extends Feature {
  Inventory() : super (image: Image.asset('assets/images/inventory.png', excludeFromSemantics: true,), label: "TỒN KHO", nextRoute: '/inventory');
}
class Highlight extends Feature {
  Highlight() : super (image: Image.asset('assets/images/highlighter.png', excludeFromSemantics: true,), label: "THÔNG TIN CUỐI NGÀY ", nextRoute: '/highlight');
}
class SyncData extends Feature {
  SyncData() : super (image: Image.asset('assets/images/sync.png', excludeFromSemantics: true,), label: "ĐỒNG BỘ DỮ LIỆU", nextRoute: '/sync_data');
}
//class ProductRequirement extends Feature {
//  ProductRequirement() : super (image: Image.asset('assets/images/gift.png', excludeFromSemantics: true,), label: "YÊU CẦU HÀNG", nextRoute: ProductRequirementPage());
//}



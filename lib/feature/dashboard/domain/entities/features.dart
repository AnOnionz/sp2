import 'package:flutter/material.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/feature/highlight/presentation/screens/highlight_page.dart';
import 'package:sp_2021/feature/inventory/presentation/screens/inventory_page.dart';
import 'package:sp_2021/feature/product_requirement/presentation/screens/product_requirement.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_form.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_page.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/screens/rival_sale_price_page.dart';
import 'package:sp_2021/feature/sale_price/presentation/screens/sale_price_page.dart';


class Feature {

  final Image image;
  final String label;
  final Widget nextRoute;

   const Feature({this.image, this.label, this.nextRoute});

}
List<ProductEntity>
products = <ProductEntity>[
    Heneiken(brandId: 1, productId: 1,productName: "Heneiken", count: 10, imgUrl: "", price: 10000),
    Heneiken0(brandId: 1, productId: 1,productName: "Heneiken 0.0", count: 10, imgUrl: "", price: 10000),
    HeneikenSilver(brandId: 1, productId: 1,productName: "Heineken Silver", count: 10, imgUrl: "", price: 10000),
    Tiger(brandId: 1, productId: 1,productName: "Tiger", count: 10, imgUrl: "", price: 10000),
    TigerCrystal(brandId: 1, productId: 1,productName: "TigerCrystal", count: 10, imgUrl: "", price: 10000),
    BiaViet(brandId: 1, productId: 1,productName: "BiaViet", count: 10, imgUrl: "", price: 10000),
    Larue(brandId: 1, productId: 1,productName: "Larue", count: 10, imgUrl: "", price: 10000),
    Bivina(brandId: 1, productId: 1,productName: "Bivina", count: 10, imgUrl: "", price: 10000),
    StrongBow(brandId: 1, productId: 1,productName: "StrongBow", count: 10, imgUrl: "", price: 10000)
];
List<RivalProductEntity> rivals = <RivalProductEntity>[
    RivalProductEntity(price: 0, name: "Sài gòn"),
    RivalProductEntity(price: 0, name: "Sài gò"),
    RivalProductEntity(price: 0, name: "Sài g"),
    RivalProductEntity(price: 0, name: "Sài "),
    RivalProductEntity(price: 0, name: "Sài"),
    RivalProductEntity(price: 0, name: "Sài d"),
];
class LuckyWheel extends Feature {
  LuckyWheel() : super (image: Image.asset('assets/images/lottery.png', excludeFromSemantics: true,), label: "QUAY QUÀ", nextRoute: ReceiveGiftPage());
}
class SalePrice extends Feature {
  SalePrice() : super (image: Image.asset('assets/images/sale.png', excludeFromSemantics: true,), label: "GIÁ BIA BÁN",nextRoute: SalePricePage(products: products));
}
class RivalSalePrice extends Feature {
  RivalSalePrice() : super (image: Image.asset('assets/images/competition.png', excludeFromSemantics: true,), label: "GIÁ BIA ĐỐI THỦ", nextRoute: RivalSalePricePage(products: rivals,));
}
class Inventory extends Feature {
  Inventory() : super (image: Image.asset('assets/images/inventory.png', excludeFromSemantics: true,), label: "TỒN KHO", nextRoute: InventoryPage(products: products,));
}
class Highlight extends Feature {
  Highlight() : super (image: Image.asset('assets/images/highlighter.png', excludeFromSemantics: true,), label: "HIGHLIGHT CUỐI NGÀY ", nextRoute: HighLightPage());
}
class ProductRequirement extends Feature {
  ProductRequirement() : super (image: Image.asset('assets/images/gift.png', excludeFromSemantics: true,), label: "YÊU CẦU HÀNG", nextRoute: ProductRequirementPage());
}


import 'dart:io';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';

import 'customer_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';


class ReceiveGiftEntity {
  String outletCode;
  final CustomerEntity customer;
  final List<ProductEntity> products;
  final List<GiftEntity> gifts;
  final List<File> productImage;
  final List<File> customerImage;
  final List<File> receiptImage;
  final int voucherReceived;
  final VoucherEntity voucher;

  ReceiveGiftEntity({this.outletCode, this.customer, this.products, this.gifts, this.productImage, this.customerImage, this.receiptImage, this.voucherReceived, this.voucher});

  CustomerGiftEntity toCustomerGift(){
    return CustomerGiftEntity(
      outletCode: outletCode,
      customer: customer,
      products: products.map((e) => e.toBuyQtyJson()).toList(),
      gifts: gifts.map((e) => e.toJson()).toList(),
      productImage: productImage.map((e) => e.path).toList(),
      customerImage: customerImage.map((e) => e.path).toList(),
      receiptImage: receiptImage.map((e) => e.path).toList(),
      voucherReceived: voucherReceived,
      voucherPhone: voucher != null ? voucher.phone : "0",
      voucherQty: voucher != null ? voucher.qty : 0,
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'name': "Result",
      'outletCode': outletCode,
      'customer': customer.toJson(),
      'products': products.map((e) => {"id": e.productId, "buyQty": e.buyQty}).toList(),
      'productImage': productImage.map((e) => {'id': e.path}).toList(),
      'customerImage': customerImage.map((e) => {'id': e.path}).toList(),
      'receiptImage': receiptImage.map((e) => {'id': e.path}).toList(),
      'voucherReceived': voucherReceived,
      'voucherPhone': voucher.phone,
      'voucherQty': voucher.qty,
    };
  }
  factory ReceiveGiftEntity.fromJson(Map<String, dynamic> json){
    return ReceiveGiftEntity(
      outletCode: json['outletCode'],

    );
  }

  @override
  String toString() {
    return 'ReceiveGiftEntity{customer: $customer, products: $products, gifts: $gifts, takeProductImage: $productImage, takeGiftImage: $customerImage, approveImage: $receiptImage}';
  }
}
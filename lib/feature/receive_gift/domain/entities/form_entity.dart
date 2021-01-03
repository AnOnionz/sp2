import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';

class FormEntity extends Equatable {
  CustomerEntity customer;
  List<ProductEntity> products;
  VoucherEntity voucher;
  bool isCheckedVoucher;
  List<File> images;

  FormEntity(
      {this.customer,
      @required this.products,
      this.voucher,
      this.isCheckedVoucher = false,
      this.images});

  Map<String, dynamic> toJson(){
    return {
      "name": customer.name,
      "phone": customer.phoneNumber,
      "products": products.map((e) => {"id": e.productId, "buyQty": e.buyQty}).toList(),
      "voucher": voucher,
      "isCheckedVoucher": isCheckedVoucher,
      "images": images.map((e) => e.path).toList(),
    };
  }

  @override
  List<Object> get props =>
      [customer, products, voucher, isCheckedVoucher, images];

  @override
  String toString() {
    return 'FormEntity{customer: $customer, products: $products, voucher: $voucher, isCheckedVoucher: $isCheckedVoucher, images: $images}';
  }
}

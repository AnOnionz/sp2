import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';

// ignore: must_be_immutable
class FormEntity extends Equatable {
  CustomerEntity customer;
  List<ProductEntity> products;
  VoucherEntity voucher;
  bool isCheckedVoucher;
  bool isUseMagnum;
//  List<File> images;

  FormEntity(
      {this.customer,
      @required this.products,
      this.voucher,
      this.isCheckedVoucher = false,
        this.isUseMagnum = false,
     });

  Map<String, dynamic> toJson(){
    return {
      "customer": customer.toCacheJson(),
      "products": jsonEncode(products.map((e) => e.toJson()).toList()),
      "voucher": voucher.toJson(),
      "isCheckedVoucher": isCheckedVoucher,
      //"images": images.map((e) => e.path).toList(),
    };
  }
  factory FormEntity.fromJson(Map<String, dynamic> json){
    return FormEntity(
      customer: CustomerEntity.fromJson(json['customer']),
      products: ( jsonDecode(json['products']) as List ).map((e) => ProductEntity.fromJson(e)).toList(),
      voucher: VoucherEntity.fromJson(json['voucher']),
      isCheckedVoucher: json['isCheckedVoucher'],
    );
  }

  @override
  List<Object> get props =>
      [customer, products, voucher, isCheckedVoucher,isUseMagnum];

  @override
  String toString() {
    return 'FormEntity{customer: $customer, products: $products, voucher: $voucher, isCheckedVoucher: $isCheckedVoucher, isUseMagnum: $isUseMagnum}';
  }
}

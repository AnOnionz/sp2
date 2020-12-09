import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/app/entities/product_entity.dart';

class FormEntity extends Equatable {
  String name;
  String phoneNumber;
  List<ProductEntity> products;
  String voucher;
  bool isCheckedVoucher;
  List<File> images;

  FormEntity(
      {this.name,
      this.phoneNumber,
      @required this.products,
      this.voucher,
      this.isCheckedVoucher = false,
      this.images});

  FormEntity copyWith(
      {String name,
      String phone,
      String voucher,
      List<ProductEntity> products,
      bool isCheckVoucher,
      List<File> images}) {
    return FormEntity(
        name: name ?? this.name,
        phoneNumber: phone ?? this.phoneNumber,
        voucher: voucher ?? this.voucher,
        products: products ?? this.products,
        isCheckedVoucher: isCheckedVoucher ?? this.isCheckedVoucher,
        images: images ?? this.images);
  }

  @override
  List<Object> get props =>
      [name, phoneNumber, products, voucher, isCheckedVoucher, images];
}

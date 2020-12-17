import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_2021/core/entities/product_entity.dart';

class FormEntity extends Equatable {
  String name;
  String phoneNumber;
  final List<ProductEntity> products;
  String voucher;
  bool isCheckedVoucher;
  int numberOfVoucher;
  List<File> images;

  FormEntity(
      {this.name, this.phoneNumber,
      @required this.products,
      this.voucher,
      this.isCheckedVoucher = false,
        this.numberOfVoucher,
      this.images});

  FormEntity copyWith(
      {String name,
      String phone,
      String voucher,
      List<ProductEntity> products,
      bool isCheckVoucher,
        int numberOfVoucher,
      List<File> images}) {
    return FormEntity(
        name: name ?? this.name,
        phoneNumber: phone ?? this.phoneNumber,
        voucher: voucher ?? this.voucher,
        products: products ?? this.products,
        numberOfVoucher: numberOfVoucher ?? this.numberOfVoucher,
        isCheckedVoucher: isCheckedVoucher ?? this.isCheckedVoucher,
        images: images ?? this.images);
  }

  @override
  List<Object> get props =>
      [name, phoneNumber, products, voucher, isCheckedVoucher, images, numberOfVoucher];

  @override
  String toString() {
    return 'FormEntity{name: $name, phoneNumber: $phoneNumber, products: $products, voucher: $voucher, isCheckedVoucher: $isCheckedVoucher, numberOfVoucher: $numberOfVoucher, images: $images}';
  }
}

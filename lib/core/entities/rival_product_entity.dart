import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'rival_product_entity.g.dart';
@HiveType(typeId: 9)
class RivalProductEntity extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int price;
  @HiveField(2)
  final String imgUrl;

  TextEditingController priceController = TextEditingController();
  FocusNode focus = FocusNode();
  RivalProductEntity({this.name, this.price, this.imgUrl});

}
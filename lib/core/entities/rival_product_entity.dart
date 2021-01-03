import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'rival_product_entity.g.dart';
@HiveType(typeId: 9)
class RivalProductEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int price;
  @HiveField(3)
  final String imgUrl;

  TextEditingController priceController = TextEditingController();
  FocusNode focus = FocusNode();
  RivalProductEntity({this.id, this.name, this.price, this.imgUrl}){
    price = price ?? 0;
  }

  factory RivalProductEntity.fromJson(Map<String, dynamic> json){
    return RivalProductEntity(
      id: json['id'],
      name: json['name'],
      imgUrl: json['img_url']
    );
  }

  @override
  String toString() {
    return 'RivalProductEntity{id: $id, name: $name, price: $price, imgUrl: $imgUrl}';
  }
}
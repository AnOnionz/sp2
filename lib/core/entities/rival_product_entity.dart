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
  @HiveField(4)
  bool isAvailable;

  TextEditingController priceController = TextEditingController();
  FocusNode focus = FocusNode();
  RivalProductEntity({this.id, this.name, this.price, this.imgUrl, this.isAvailable}){
    price = price ?? 0;
  }

  factory RivalProductEntity.fromJson(Map<String, dynamic> json){
    return RivalProductEntity(
      id: json['id'],
      name: json['name'],
      imgUrl: json['img_url'],
      isAvailable: json['img_url'] != "https://sptt21.imark.vn/" ? true : false,
    );
  }
  @override
  RivalProductEntity copyWith({int price}) {
    return RivalProductEntity(
        name: this.name,
        id: this.id,
        imgUrl: this.imgUrl,
        price: price ?? this.price,
        isAvailable: this.isAvailable);
  }

  @override
  String toString() {
    return 'RivalProductEntity{id: $id, name: $name, price: $price, imgUrl: $imgUrl, isAvailable: $isAvailable, priceController: $priceController, focus: $focus}';
  }
}
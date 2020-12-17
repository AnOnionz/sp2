import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';

part 'receive_gift_entity.g.dart';

@HiveType(typeId: 5)
class ReceiveGiftEntity extends Equatable with HiveObject{
  @HiveField(0)
  final CustomerEntity customer;
  @HiveField(1)
  final List<ProductEntity> products;
  @HiveField(2)
  final List<GiftEntity> giftReceived;
  @HiveField(3)
  final int createAt;

  ReceiveGiftEntity({this.customer, this.products, this.giftReceived, this.createAt});



  @override
  List<Object> get props => [customer, products, giftReceived, createAt];

  @override
  String toString() {
    return 'ReceiveGiftEntity{customer: $customer, products: $products, giftReceived: $giftReceived, createAt: $createAt}';
  }
}
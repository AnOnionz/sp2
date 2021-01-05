import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'customer_entity.dart';

part 'customer_gift_entity.g.dart';

@HiveType(typeId: 20)
// ignore: must_be_immutable
class CustomerGiftEntity extends Equatable with HiveObject{
  @HiveField(0)
  final String outletCode;
  @HiveField(1)
  final CustomerEntity customer;
  @HiveField(2)
  final List<dynamic> products;
  @HiveField(3)
  final List<dynamic> gifts;
  @HiveField(4)
  final List<String> productImage;
  @HiveField(5)
  final List<String> customerImage;
  @HiveField(6)
  final List<String> receiptImage;
  @HiveField(7)
  final int voucherReceived;
  @HiveField(8)
  final String voucherPhone;
  @HiveField(9)
  final int voucherQty;

  CustomerGiftEntity({this.outletCode, this.customer, this.products, this.gifts, this.productImage, this.customerImage, this.receiptImage, this.voucherPhone ,this.voucherQty ,this.voucherReceived});

  Map<String, dynamic> toJson() {
    return {
      'outlet_code': outletCode,
      'customer': customer.toJson(),
      'products': products,
      'gifts': gifts ,
      'product_images': productImage.map((e) =>
          MultipartFile.fromFileSync(
            e, filename: basename(e),
          ),).toList(),
      'customer_images': customerImage.map((e) =>
          MultipartFile.fromFileSync(
            e, filename: basename(e),
          ),).toList(),
      'receipt_images': receiptImage.map((e) =>
          MultipartFile.fromFileSync(
            e, filename: basename(e),
          ),).toList(),
      'voucher_received': voucherReceived.toString(),
      'voucher_used': {
        'phone': voucherPhone,
        'qty': voucherQty.toString(),
      }
    };
  }

  @override
  String toString() {
    return 'CustomerGiftEntity{outletCode: $outletCode, customer: $customer, products: $products, gifts: $gifts, productImage: $productImage, customerImage: $customerImage, receiptImage: $receiptImage, voucherReceived: $voucherReceived, voucherPhone: $voucherPhone, voucherQty: $voucherQty}';
  }

  @override
  List<Object> get props => [customer, products, gifts, productImage, customerImage, receiptImage, voucherQty, voucherPhone, voucherReceived];
}
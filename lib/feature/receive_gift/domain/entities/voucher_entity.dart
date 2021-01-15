import 'package:equatable/equatable.dart';

class VoucherEntity extends Equatable{
  final String phone;
  final int qty;

  VoucherEntity({this.phone, this.qty});

  Map<String, dynamic> toJson(){
    return {
      "phone": phone,
      "qty": qty,
    };
  }

  factory VoucherEntity.fromJson(Map<String, dynamic> json){
    return VoucherEntity(
      phone: json['phone'],
      qty: json['qty']
    );
  }

  @override
  List<Object> get props => [phone];

  @override
  String toString() {
    return 'VoucherEntity{phone: $phone, qty: $qty}';
  }
}
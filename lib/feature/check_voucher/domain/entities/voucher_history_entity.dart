import 'package:equatable/equatable.dart';

class VoucherHistoryEntity extends Equatable {
  final DateTime time;
  final int qty;
  final String outletName;
  final String address;
  final String spName;

  VoucherHistoryEntity(
      {this.time, this.qty, this.outletName, this.address, this.spName});

  factory VoucherHistoryEntity.fromJson(Map<String, dynamic> json) {
    return VoucherHistoryEntity(
        time: DateTime.fromMillisecondsSinceEpoch(json['used_at'] * 1000),
        qty: json['number_voucher'],
        outletName: json['outlet_name'],
        address: json['outlet_address'],
        spName: json['sp_name']);
  }
  @override
  String toString() {
    return 'VoucherHistoryEntity{time: $time, qty: $qty, outletName: $outletName, address: $address, spName: $spName}';
  }

  @override
  List<Object> get props => [time, qty, outletName, address, spName];
}

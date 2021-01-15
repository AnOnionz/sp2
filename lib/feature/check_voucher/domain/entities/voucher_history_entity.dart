import 'package:equatable/equatable.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

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
        outletName: 'Cửa hàng Bình Lợi',//json['outlet']['name'],
        address: 'Bình thạnh, Hồ Chí Minh' ,//json['outlet']['address'],
        spName: 'Nguyễn Văn Thị');//json['outlet']['se_name']);
  }
  @override
  String toString() {
    return 'VoucherHistoryEntity{time: $time, qty: $qty, outletName: $outletName, address: $address, spName: $spName}';
  }

  @override
  List<Object> get props => [time, qty, outletName, address, spName];
}

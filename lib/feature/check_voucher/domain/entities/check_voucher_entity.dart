import 'package:equatable/equatable.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';

class CheckVoucherEntity {
  final int qty;
  final List<VoucherHistoryEntity> history;

  CheckVoucherEntity({this.qty, this.history});

  factory CheckVoucherEntity.fromJson(Map<String, dynamic> json){
    return CheckVoucherEntity(
      qty: json['current'] as int,
      history: (json['history'] as List<dynamic>).map((e) => VoucherHistoryEntity.fromJson(e)).toList()
    );
  }

}
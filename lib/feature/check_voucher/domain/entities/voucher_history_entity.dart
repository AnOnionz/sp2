import 'package:equatable/equatable.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

class VoucherHistoryEntity extends Equatable{
  final DateTime time;
  final int qty;
  final LoginEntity outlet;

  VoucherHistoryEntity({this.time, this.qty, this.outlet});


  @override
  List<Object> get props =>[time, qty, outlet];

}
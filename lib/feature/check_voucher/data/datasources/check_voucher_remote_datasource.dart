import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/check_voucher_entity.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';


abstract class CheckVoucherRemoteDataSource {
  Future<CheckVoucherEntity> checkVoucher({String code});
}
class CheckVoucherRemoteDataSourceImpl implements CheckVoucherRemoteDataSource{
  final CDio cDio;

  CheckVoucherRemoteDataSourceImpl({this.cDio});

  @override
  Future<CheckVoucherEntity> checkVoucher({String code}) async {
    Response _resp = await cDio.getResponse(path: 'home/search-voucher', data: {'phone': code});

    print(_resp);

    return CheckVoucherEntity.fromJson(_resp.data['data']);
  }

}
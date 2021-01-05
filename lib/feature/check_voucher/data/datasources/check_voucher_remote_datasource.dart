import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';


abstract class CheckVoucherRemoteDataSource {
  Future<List<VoucherHistoryEntity>> checkVoucher({String code});
}
class CheckVoucherRemoteDataSourceImpl implements CheckVoucherRemoteDataSource{
  final CDio cDio;

  CheckVoucherRemoteDataSourceImpl({this.cDio});

  @override
  Future<List<VoucherHistoryEntity>> checkVoucher({String code}) async {
    Response _resp = await cDio.getResponse(path: 'home/search-voucher', data: {'phone': code});

    print(_resp);

    return (_resp.data['data']['history'] as List<dynamic>).map((e) => VoucherHistoryEntity.fromJson(e)).toList();
  }

}
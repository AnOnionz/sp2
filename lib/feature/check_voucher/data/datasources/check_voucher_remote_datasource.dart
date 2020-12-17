import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';

import '../../../../di.dart';

abstract class CheckVoucherRemoteDataSource {
  Future<List<VoucherHistoryEntity>> checkVoucher({String code});
}
class CheckVoucherRemoteDataSourceImpl implements CheckVoucherRemoteDataSource{

  @override
  Future<List<VoucherHistoryEntity>> checkVoucher({String code}) async{
    return [VoucherHistoryEntity(time: DateTime.now(), outlet: await sl<SecureStorage>().readUser(key: OUTLET_IN_STORAGE), qty: 1)];
  }

}
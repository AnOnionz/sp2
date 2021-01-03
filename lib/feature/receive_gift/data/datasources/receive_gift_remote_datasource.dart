import 'package:dio/dio.dart';
import 'package:sp_2021/core/api/myDio.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';

abstract class ReceiveGiftRemoteDataSource{
  Future<bool> updateSetGiftCurrentToServer(SetGiftEntity setGiftEntity);
  Future<bool> updateCustomerGiftToServer(CustomerGiftEntity customerGiftEntity);
  Future<VoucherEntity> useVoucher(String phone);
}
class ReceiveGiftRemoteDataSourceImpl implements ReceiveGiftRemoteDataSource{
  final CDio cDio;

  ReceiveGiftRemoteDataSourceImpl({this.cDio});

  @override
  Future<bool> updateCustomerGiftToServer(CustomerGiftEntity customerGiftEntity) async {

    print(customerGiftEntity.toJson());
    Response _resp = await cDio.postResponse(path: 'home/customer', data: FormData.fromMap(customerGiftEntity.toJson()));

    return _resp.data['success'];
  }

  @override
  Future<bool> updateSetGiftCurrentToServer(SetGiftEntity setGiftEntity) async {
    Response _resp = await cDio.postResponse(path: 'home/outlet-set-gift-current', data: setGiftEntity.toJson());

    return _resp.data['success'];
  }

  @override
  Future<VoucherEntity> useVoucher(String phone) async {
    Response _resp = await cDio.getResponse(path: 'home/check-voucher', data: {'phone': phone});

    return VoucherEntity(qty: _resp.data['data']['current'], phone: phone);
  }

}
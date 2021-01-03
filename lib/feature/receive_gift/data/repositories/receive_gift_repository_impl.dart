import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_local_datasource.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_remote_datasource.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_wheel_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';

class ReceiveGiftRepositoryImpl implements ReceiveGiftRepository {
  final SecureStorage storage;
  final ReceiveGiftLocalDataSource local;
  final ReceiveGiftRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ReceiveGiftRepositoryImpl(
      {this.storage, this.local, this.remote, this.networkInfo});

  @override
  Future<Either<Failure, VoucherEntity>> useVoucher({String phone}) async {
    if (await networkInfo.isConnected) {
      try {
        final voucher = await remote.useVoucher(phone);
        return Right(voucher);
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      }
    }else{
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, HandleGiftEntity>> handleGift(
      {List<ProductEntity> products,
      CustomerEntity customer,
      SetGiftEntity setCurrent}) async {
    try {
      final result = await local.handleGift(
          products: products, setCurrent: setCurrent, customer: customer);
      return Right(result);
    } on SetOver {
      return Left(SetOverFailure());
    }
  }

  @override
  Future<Either<Failure, HandleWheelEntity>> handleWheel(
      {List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async {
    try {
      final result = await local.handleWheel(
          setCurrent: setCurrent, giftReceived: giftReceived);
      return Right(result);
    } on SetOver catch (e) {
      return Left(SetOverFailure());
    }
  }

  @override
  Future<Either<Failure, HandleWheelEntity>> handleStrongBowWheel(
      {List<GiftEntity> giftReceived, SetGiftEntity setCurrent}) async {
    try {
      final result = await local.handleStrongBowWheel(
          setCurrent: setCurrent, giftReceived: giftReceived);
      return Right(result);
    } on SetOver catch (e) {
      return Left(SetOverFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> handleReceiveGift(
      {ReceiveGiftEntity receiveGiftEntity, SetGiftEntity setCurrent}) async {
    if (await networkInfo.isConnected) {
      try{
        final time = DateTime.now();
        receiveGiftEntity.outletCode =
            'INIT_CODE'; //AuthenticationBloc.outlet.code;
        receiveGiftEntity.customer.inTurn -= receiveGiftEntity.gifts.length;
        receiveGiftEntity.customer.deviceCreatedAt =
            time.millisecondsSinceEpoch ~/ 1000;
        print(receiveGiftEntity.customer.deviceCreatedAt);
        final updateCustomerGift = await remote
            .updateCustomerGiftToServer(receiveGiftEntity.toCustomerGift());
        print(1);
        final updateSetCurrent =
            await remote.updateSetGiftCurrentToServer(setCurrent);
        print(1);
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        print(1);
        return Right(updateSetCurrent && updateCustomerGift);
      } on InternetException catch (_) {
        await local.cacheCustomerGift(
            customerGiftEntity: receiveGiftEntity.toCustomerGift());
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        return Left(NotInternetItWillCacheLocalFailure());
      } on InternalException catch (_) {
        await local.cacheCustomerGift(
            customerGiftEntity: receiveGiftEntity.toCustomerGift());
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        return Left(InternalFailure());
      } on UnAuthenticateException catch (_) {
        await local.cacheCustomerGift(
            customerGiftEntity: receiveGiftEntity.toCustomerGift());
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } catch(e){
        print(e.toString());
      }
    } else {
      await local.cacheCustomerGift(
          customerGiftEntity: receiveGiftEntity.toCustomerGift());
      return Left(NotInternetItWillCacheLocalFailure());
    }
  }

  @override
  Future<void> syncReceiveGift() async {
    if(await hasSync()) {
        final data = await local.fetchCustomerGift();
        print(data);
        for (int i = 0; i < data.length; i++) {
          await remote.updateCustomerGiftToServer(data[i]);
          await local.clearCustomerGift();
        }
        await local.clearAllCustomerGift();
      }
    }


  @override
  Future<bool> hasSync() async {
    return local.isRequireSync();
  }

}

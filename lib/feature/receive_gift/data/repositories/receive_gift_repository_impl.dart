import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/domain/usecases/update_set_gift_usecase.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_local_datasource.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_remote_datasource.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/handle_wheel_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/repositories/receive_gift_repository.dart';
import 'package:sp_2021/feature/sync_data/data/datasources/sync_local_data_source.dart';

class ReceiveGiftRepositoryImpl implements ReceiveGiftRepository {
  final ReceiveGiftLocalDataSource local;
  final ReceiveGiftRemoteDataSource remote;
  final DashBoardLocalDataSource dashboardLocal;
  final UpdateDataUseCase updateSetGift;
  final NetworkInfo networkInfo;


  ReceiveGiftRepositoryImpl(
      {this.local, this.remote, this.networkInfo, this.dashboardLocal, this.updateSetGift,});

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
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, HandleGiftEntity>> handleGift(
      {List<ProductEntity> products,
      CustomerEntity customer,
      SetGiftEntity setCurrent, SetGiftEntity setSBCurrent}) async {
    try {
      final result = await local.handleGift(
          products: products, setCurrent: setCurrent, customer: customer, setSBCurrent: setSBCurrent);
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
    } on SetOver catch (_) {
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
    } on SetOver catch (_) {
      return Left(SetOverFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> handleReceiveGift(
      {ReceiveGiftEntity receiveGiftEntity, SetGiftEntity setCurrent, SetGiftEntity setSBCurrent}) async {
    final time = DateTime.now();
    receiveGiftEntity.outletCode = AuthenticationBloc.outlet.code; //AuthenticationBloc.outlet.code;
    receiveGiftEntity.customer.deviceCreatedAt =
        time.millisecondsSinceEpoch ~/ 1000;
    if (await networkInfo.isConnected) {
      try {
        print(receiveGiftEntity.toCustomerGift());
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        await remote.updateSetGiftCurrentToServer(setCurrent) ;
        final updateSetSBCurrent = setSBCurrent !=null && AuthenticationBloc.outlet.province == 'HN_HCM'
            ? await remote.updateSetGiftSBCurrentToServer(setSBCurrent)
            : true;
        final updateCustomerGift = await remote
            .updateCustomerGiftToServer(receiveGiftEntity.toCustomerGift());
        await updateSetGift(NoParams());
        dashboardLocal.cacheChangedSet(false);
       // print(receiveGiftEntity.toCustomerGift().products.fold(0, (previousValue, element) => previousValue + element['qty']));
        return Right(updateCustomerGift);
      } on InternetException catch (_) {
        await local.cacheCustomerGift(
            customerGiftEntity: receiveGiftEntity.toCustomerGift());
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        return Left(InternetFailure());
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
        await local.cacheCustomerGift(
            customerGiftEntity: receiveGiftEntity.toCustomerGift());
        await local.cacheCustomer(customer: receiveGiftEntity.customer);
        return Left(ResponseFailure(message: error.message));
      }
    } else {
      await local.cacheCustomerGift(
          customerGiftEntity: receiveGiftEntity.toCustomerGift());
      await local.cacheCustomer(customer: receiveGiftEntity.customer);
      return Left(InternetFailure());
    }
  }

  @override
  Future<void> syncReceiveGift() async {
    if (await hasSync()) {
      final data = local.fetchCustomerGift();
      final setCurrent = dashboardLocal.fetchSetGiftCurrent();
      final setSBCurrent = dashboardLocal.fetchSetGiftSBCurrent();
      await remote.updateSetGiftCurrentToServer(setCurrent);
      final updateSetSBCurrent = setSBCurrent !=null && AuthenticationBloc.outlet.province == 'HN_HCM'
          ? await remote.updateSetGiftSBCurrentToServer(setSBCurrent)
          : true;
      for (CustomerGiftEntity cf in data){
        cf.customer.gender = cf.customer.gender ?? '1';
        cf.outletCode = AuthenticationBloc.outlet.code;
        await remote.updateCustomerGiftToServer(cf);
        await local.clearCustomerGift();
        dashboardLocal.cacheChangedSet(false);
        dashboardLocal.updateKpi(cf.products);
      }
      await local.clearAllCustomerGift();
      await updateSetGift(NoParams());
    }
  }

  @override
  Future<bool> hasSync() async {
    return local.isRequireSync();
  }

}

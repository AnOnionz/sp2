import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/receive_gift/data/datasources/receive_gift_local_datasource.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/voucher_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_gift_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_receive_gift_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_strongbow_wheel_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_wheel_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/use_voucher_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/validate_form_usecase.dart';

import '../../../../di.dart';

part 'receive_gift_event.dart';
part 'receive_gift_state.dart';

class ReceiveGiftBloc extends Bloc<ReceiveGiftEvent, ReceiveGiftState> {
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  final SharedPreferences sharedPrefer;
  final DashBoardLocalDataSource localData;
  final ReceiveGiftLocalDataSource local;
  final HandleGiftUseCase handleGift;
  final HandleWheelUseCase handleWheel;
  final HandleStrongBowWheelUseCase handleStrongBowWheel;
  final HandleReceiveGiftUseCase handleReceiveGift;
  final ValidateFormUseCase validateForm;
  final UseVoucherUseCase useVoucher;

  SetGiftEntity setCurrent;
  SetGiftEntity setSBCurrent;
  ReceiveGiftBloc(
      {this.authenticationBloc,
      this.dashboardBloc,
        this.sharedPrefer,
      this.handleWheel,
      this.handleStrongBowWheel,
      this.handleGift,
      this.localData,
      this.local,
      this.handleReceiveGift,
      this.useVoucher,
      this.validateForm})
      : super(ReceiveGiftFormStateInitial());

  @override
  Stream<ReceiveGiftState> mapEventToState(
    ReceiveGiftEvent event,
  ) async* {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (event is ReceiveGiftStart) {
      setCurrent = localData.fetchSetGiftCurrent();
      final dataToday = localData.dataToday;
      final outlet = AuthenticationBloc.outlet;
      if (dataToday.checkIn != true) {
        dashboardBloc.add(RequiredCheckInOrCheckOut(
            message: 'Phải chấm công trước khi đổi quà', willPop: 2));
        return ;
      }
      ReceiveGiftState stateCached = getState();
      if(stateCached != null){
        yield stateCached;
      }
    }
    if (event is UseVoucher) {
      yield UseVoucherLoading();
      final voucher = await useVoucher(event.phone);
      yield* _eitherCheckVoucherToState(
          voucher, dashboardBloc, authenticationBloc);
    }
    if (event is ReceiveGiftSubmitForm) {
      print('FORM: ${event.form}');
      final validator =
          await validateForm(ValidateFormParams(form: event.form));
      yield* _eitherValidateToState(validator);
    }
    if (event is ReceiveGiftConfirm) {
      final pd = event.form.products.where((element) => element is! StrongBowPack6).toList().fold(0, (previousValue, element) => previousValue + element.buyQty);
      if (setCurrent.gifts.firstWhere((element) => element is Magnum).amountCurrent == 0 || localData.isSetOver || pd < 5 || !event.form.isUseMagnum ) {
        yield ReceiveGiftNotCondition();
        add(ReceiveGiftOnlyBuyProducts(form: event.form));
      } else {
        final mn = pd ~/ 5 < setCurrent.gifts.firstWhere((element) => element is Magnum).amountCurrent ? pd ~/ 5 : setCurrent.gifts.firstWhere((element) => element is Magnum).amountCurrent ;
        yield ReceiveGiftStateNow(
          form: event.form,
          giftAt: 0,
          giftReceive: [Magnum(
            giftId: 7,
            name: 'Chai Magnum',
            amountReceive: mn,
            assetGift: 'hn_magnum',
            image: 'https://sptt21.imark.vn/image/sku/HinhQua/Magnum.png',
          )],
          giftReceived: [Magnum(
            giftId: 7,
            name: 'Chai Magnum',
            amountReceive: mn,
            assetGift: 'hn_magnum',
            image: 'https://sptt21.imark.vn/image/sku/HinhQua/Magnum.png',
          )],
          giftSBReceived: [],
        );
        }
      }
    if(event is ReceiveGiftOnlyBuyProducts){
      final ReceiveGiftEntity receiveGiftEntity = ReceiveGiftEntity(
          customer: event.form.customer,
        products: event.form.products,
        voucher: event.form.voucher,
        gifts: [],
        voucherReceived: 0,
        //productImage: event.form.images,
        customerImage: [],
      );
      receiveGiftEntity.customer.deviceCreatedAt = DateTime.now().millisecondsSinceEpoch ~/1000;
      sl<DashBoardLocalDataSource>().cacheDataToday(customerGiftEntity: receiveGiftEntity.toCustomerGift());
      await handleReceiveGift(HandleReceiveGiftParams(
          receiveGiftEntity: receiveGiftEntity, setCurrent: setCurrent, setSBCurrent: setSBCurrent));
    }
    if (event is GiftNext) {
         setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => e.giftId == 7 ? e.downCurrent(event.giftReceived[0].amountReceive) : e)
                  .toList());

      if (event.giftAt == event.giftReceive.length) {
        add(ReceiveGiftResult(
            receiveGiftEntity: ReceiveGiftEntity(
                customer: event.form.customer,
                gifts: event.giftReceived,
                products: event.form.products,
                //productImage: event.form.images,
                voucher: event.form.voucher,
                customerImage: [])));
      } else {
        if (event.giftReceive.elementAt(event.giftAt) is Wheel) {
          final lucky = await handleWheel(HandleWheelParams(
              giftReceived: event.giftReceived, setCurrent: setCurrent));
          yield lucky.fold((l) {
            if (l is SetOverFailure) {
              event.form.customer.inSBTurn -= event.giftSBReceived.length;
              event.form.customer.inTurn -= event.giftReceived.length;
              add(ReceiveGiftResult(
                  receiveGiftEntity: ReceiveGiftEntity(
                      voucher: event.form.voucher,
                      customer: event.form.customer,
                      gifts: [...event.giftReceived, ...event.giftSBReceived],
                      products: event.form.products,
                      //productImage: event.form.images,
                      customerImage: [])));
              return null;
            }
            return ReceiveGiftFailure();
          }, (result) {
            setCurrent = result.setCurrent;
            return ReceiveGiftStateWheel(
                form: event.form,
                giftLucky: result.lucky,
                giftReceive: event.giftReceive,
                giftReceived: event.giftReceived,
                giftSBReceived: event.giftSBReceived,
                giftAt: event.giftAt);
          });
        }
        if (event.giftReceive.elementAt(event.giftAt) is StrongBowWheel) {
          final lucky = await handleStrongBowWheel(HandleStrongBowWheelParams(
              giftReceived: event.giftSBReceived, setCurrent: setSBCurrent));
          yield lucky.fold((l) {
            if (l is SetOverFailure) {
              event.form.customer.inSBTurn -= event.giftSBReceived.length;
              event.form.customer.inTurn -= event.giftReceived.length;
              add(ReceiveGiftResult(
                  receiveGiftEntity: ReceiveGiftEntity(
                      voucher: event.form.voucher,
                      customer: event.form.customer,
                      products: event.form.products,
                      gifts: [...event.giftReceived, ...event.giftSBReceived],
                      //productImage: event.form.images,
                      customerImage: [])));
              return null;
            }
            return ReceiveGiftFailure();
          }, (result) {
            setSBCurrent = result.setCurrent;
            return ReceiveGiftStateSBWheel(
                form: event.form,
                giftLucky: result.lucky,
                giftReceive: event.giftReceive,
                giftReceived: event.giftReceived,
                giftSBReceived: event.giftSBReceived,
                giftAt: event.giftAt);
          });
        }
        if (event.giftReceive.elementAt(event.giftAt) is GiftEntity) {
            yield ReceiveGiftStateWheel(
                form: event.form,
                giftLucky: [event.giftReceive.elementAt(event.giftAt)],
                giftReceive: event.giftReceive,
                giftReceived: event.giftReceived,
                giftSBReceived: event.giftSBReceived,
                giftAt: event.giftAt);
//          yield ReceiveGiftStateNow(
//              form: event.form,
//              giftReceive: event.giftReceive,
//              giftReceived: [
//                ...event.giftReceived,
//                ...[event.giftReceive[event.giftAt]],
//              ],
//              giftSBReceived: event.giftSBReceived,
//              giftAt: event.giftAt);
        }
      }
    }
    if (event is ShowGiftWheel) {
      if(event.giftReceive[event.giftAt] is! GiftEntity) {
        event.gift is NormalGift ? setCurrent = SetGiftEntity(
            index: setCurrent.index,
            gifts: setCurrent.gifts
                .map((e) => event.gift.id == e.giftId ? e.downCurrent(e.amountReceive) : e)
                .toList()) :
        setSBCurrent = SetGiftEntity(
            index: setSBCurrent.index,
            gifts: setSBCurrent.gifts
                .map((e) => event.gift.id == e.giftId ? e.downCurrent(e.amountReceive) : e)
                .toList());
      }
      yield ReceiveGiftStateNow(
          form: event.form,
          giftReceive: event.giftReceive,
          giftReceived: [
            ...event.giftReceived,
            ...event.gift is NormalGift ? [event.gift] : [],
          ],
          giftSBReceived: [...event.giftSBReceived, ...event.gift is OnTopGift ? [event.gift] : [],],
          giftAt: event.giftAt);
    }
    if (event is ReceiveGiftResult) {
      await localData.cacheSetGiftCurrent(setGiftEntity: setCurrent);
      print("setCurrent final: $setCurrent");
      ReceiveGiftState result = ReceiveGiftStateResult(
          receiveGiftEntity: ReceiveGiftEntity(
            customer: event.receiveGiftEntity.customer,
            voucher: event.receiveGiftEntity.voucher,
            products: event.receiveGiftEntity.products,
            gifts: event.receiveGiftEntity.gifts,
            voucherReceived: 0,
            //productImage: event.receiveGiftEntity.productImage,
            customerImage: event.receiveGiftEntity.customerImage,
          ));
      _cacheState(result);
      yield result;
    }
    if (event is ReceiveGiftSubmit) {
      _removeState();
      event.receiveGiftEntity.customer.deviceCreatedAt = DateTime.now().millisecondsSinceEpoch ~/1000;
      sl<DashBoardLocalDataSource>().cacheDataToday(customerGiftEntity: event.receiveGiftEntity.toCustomerGift());
      await localData.cacheSetGiftCurrent(setGiftEntity: setCurrent);
      final finish = await handleReceiveGift(HandleReceiveGiftParams(
          receiveGiftEntity: event.receiveGiftEntity, setCurrent: setCurrent, setSBCurrent: setSBCurrent));
      yield finish.fold((fail) {
        if (fail is UnAuthenticateFailure) {
          authenticationBloc.add(ShutDown(willPop: 1));
        }
        if (fail is InternalFailure) {
          dashboardBloc.add(InternalServer(willPop: 0));
        }
        if (fail is InternetFailure) {
          dashboardBloc.add(AccessInternet());
        }else{
          dashboardBloc.add(ThrowFailure(message: fail.message,));
        }
        return null;
      }, (r) {
        return null;
      });
    }
  }

  List<ProductEntity> merge(List<ProductEntity> products) {
    int heineken, tiger, strongbow, normal, strongbow6 ;
    heineken = tiger = strongbow = normal = strongbow6 = 0;
    products.forEach((element) {
      if (element is Heineken)
        heineken += element.buyQty;
      if (element is Tiger)
        tiger += element.buyQty;
      if (element is StrongBow)
        strongbow += element.buyQty;
      if (element is NormalBeer)
        normal += element.buyQty;
      if(element is StrongBowPack6)
        strongbow6 += element.buyQty;
    });
    List<ProductEntity> result = [];
    if (heineken > 0) result.add(Heineken.internal(heineken));
    if (tiger > 0) result.add(Tiger.internal(tiger));
    if (strongbow > 0) result.add(StrongBow.internal(strongbow));
    if (normal > 0) result.add(NormalBeer.internal(normal));
    if (strongbow6 > 0) result.add(StrongBowPack6.internal(strongbow6));

    return result;
  }
  void _cacheState(ReceiveGiftState state){
    sharedPrefer.setString(AuthenticationBloc.outlet.id.toString() + STATE_IN_STORAGE, jsonEncode(state.toJson()));
  }
  ReceiveGiftState getState(){
    final stateString = sharedPrefer.getString(AuthenticationBloc.outlet.id.toString() + STATE_IN_STORAGE);
    if(stateString != null){
      return ReceiveGiftState.fromJson(jsonDecode(stateString) as Map<String ,dynamic>);
    }
    return null;
  }
  void _removeState(){
    sharedPrefer.remove(AuthenticationBloc.outlet.id.toString() + STATE_IN_STORAGE);
  }
}

Stream<ReceiveGiftState> _eitherValidateToState(
    Either<Failure, FormEntity> either) async* {
  yield either.fold((l) {
//    if (l is NoImageFailure) return NoImage();
    return FormError(message: l.message);
  }, (form) => ReceiveGiftPopup(form: form));
}

Stream<ReceiveGiftState> _eitherCheckVoucherToState(
    Either<Failure, VoucherEntity> either,
    DashboardBloc dashboardBloc,
    AuthenticationBloc authenticationBloc) async* {
  yield either.fold((fail) {
    if (fail is InternetFailure) {
      dashboardBloc.add(AccessInternet());
      return null;
    }
    if (fail is UnAuthenticateFailure) {
      authenticationBloc.add(ShutDown(willPop: 1));
      return null;
    }
    if (fail is InternalFailure) {
      dashboardBloc.add(InternalServer(willPop: 0));
      return null;
    }
    return UseVoucherFailure();
  },
      (voucher) => voucher.qty > 0
          ? UseVoucherSuccess(voucher: voucher)
          : UseVoucherFailure());
}


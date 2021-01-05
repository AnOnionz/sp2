import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
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

part 'receive_gift_event.dart';
part 'receive_gift_state.dart';

class ReceiveGiftBloc extends Bloc<ReceiveGiftEvent, ReceiveGiftState> {
  final AuthenticationBloc authenticationBloc;
  final DashboardBloc dashboardBloc;
  final DashBoardLocalDataSource localData;
  final ReceiveGiftLocalDataSource local;
  final HandleGiftUseCase handleGift;
  final HandleWheelUseCase handleWheel;
  final HandleStrongBowWheelUseCase handleStrongBowWheel;
  final HandleReceiveGiftUseCase handleReceiveGift;
  final ValidateFormUseCase validateForm;
  final UseVoucherUseCase useVoucher;
  SetGiftEntity setCurrent;
  ReceiveGiftBloc(
      {this.authenticationBloc,
      this.dashboardBloc,
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
    if (event is ReceiveGiftStart) {
      final dataToday = localData.dataToday;
      if (dataToday.checkIn != true) {
        dashboardBloc.add(RequiredCheckInOrCheckOut(
            message: 'Phải chấm công trước khi đổi quà', willPop: 2));
      }
    }
    if (event is UseVoucher) {
      yield UseVoucherLoading();
      final voucher = await useVoucher(event.phone);
      yield* _eitherCheckVoucherToState(
          voucher, dashboardBloc, authenticationBloc);
    }
    if (event is ReceiveGiftSubmitForm) {
      setCurrent = localData.fetchSetGiftCurrent();
      print(setCurrent);
      print(event.form);
      final validator =
          await validateForm(ValidateFormParams(form: event.form));
      yield* _eitherValidateToState(validator);
    }
    if (event is ReceiveGiftConfirm) {
      yield ReceiveGiftHandling(form: event.form);
      print(localData.isSetOver);
      if (localData.isSetOver) {
        yield ReceiveGiftNotCondition();
      } else {
        CustomerEntity customer = await local.getCustomer(
            name: event.form.customer.name,
            phone: event.form.customer.phoneNumber);
        print(customer);
        event.form.customer = customer;
        if (customer.inTurn == 0) {
          yield ReceiveGifShowTurn(
              form: event.form,
              gifts: [],
              message: "Hôm nay bạn đã hết lượt nhận quà",
              type: 2);
        }
        if (customer.inTurn > 0) {
          final gifts = await handleGift(HandleGiftParams(
              products: merge(event.form.products),
              customer: customer,
              setCurrent: setCurrent));
          yield gifts.fold((l) {
            if (l is SetOverFailure) {
              return ReceiveGiftNotCondition();
            }
            return ReceiveGiftFailure();
          }, (result) {
            event.form.customer = customer;
            print(result.setCurrent);
            return ReceiveGifShowTurn(
                form: event.form,
                gifts: result.gifts,
                setCurrent: result.setCurrent,
                message:
                    "Hôm nay bạn có ${result.gifts.length < customer.inTurn ? result.gifts.length : customer.inTurn} lượt nhận quà",
                type: 1);
          });
        }
      }
    }
    if(event is ReceiveGiftOnlyBuyProducts){
      final ReceiveGiftEntity receiveGiftEntity = ReceiveGiftEntity(
          customer: event.form.customer,
        products: event.form.products,
        voucher: event.form.voucher,
        gifts: [],
        voucherReceived: 0,
        receiptImage: [],
        productImage: event.form.images,
        customerImage: [],
      );
      await handleReceiveGift(HandleReceiveGiftParams(
          receiveGiftEntity: receiveGiftEntity, setCurrent: setCurrent));
    }
    if (event is GiftNext) {
      setCurrent = event.setCurrent ?? setCurrent;
      if(event.giftAt == 0){
        event.giftReceive.forEach((gift) {
          setCurrent = SetGiftEntity(
              index: setCurrent.index,
              gifts: setCurrent.gifts
                  .map((e) => gift.id == e.giftId ? e.downCurrent() : e)
                  .toList());
        });
      }
      if (event.giftAt == event.giftReceive.length) {
        add(ReceiveGiftResult(
            receiveGiftEntity: ReceiveGiftEntity(
                customer: event.form.customer,
                gifts: [...event.giftReceived, ...event.giftSBReceived],
                products: event.form.products,
                productImage: event.form.images,
                voucher: event.form.voucher,
                receiptImage: [],
                customerImage: [])));
      } else {
        if (event.giftReceive.elementAt(event.giftAt) is Wheel) {
          final lucky = await handleWheel(HandleWheelParams(
              giftReceived: event.giftReceived, setCurrent: setCurrent));
          yield lucky.fold((l) {
            if (l is SetOverFailure) {
              add(ReceiveGiftResult(
                  receiveGiftEntity: ReceiveGiftEntity(
                      voucher: event.form.voucher,
                      customer: event.form.customer,
                      gifts: [...event.giftReceived, ...event.giftSBReceived],
                      products: event.form.products,
                      productImage: event.form.images,
                      receiptImage: [],
                      customerImage: [])));
              return null;
            }
            return ReceiveGiftFailure();
          }, (result) {
            print('setCurrent after wheel: ${result.setCurrent}');
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
              giftReceived: event.giftReceived, setCurrent: setCurrent));
          yield lucky.fold((l) {
            if (l is SetOverFailure) {
              add(ReceiveGiftResult(
                  receiveGiftEntity: ReceiveGiftEntity(
                      voucher: event.form.voucher,
                      customer: event.form.customer,
                      products: event.form.products,
                      productImage: event.form.images,
                      gifts: [...event.giftReceived, ...event.giftSBReceived],
                      receiptImage: [],
                      customerImage: [])));
              return null;
            }
            return ReceiveGiftFailure();
          }, (result) {
            print('setCurrent after wheel: ${result.setCurrent}');
            setCurrent = result.setCurrent;
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
      setCurrent = SetGiftEntity(
          index: setCurrent.index,
          gifts: setCurrent.gifts
              .map((e) => event.gift.giftId == e.giftId ? e.downCurrent() : e)
              .toList());
      yield ReceiveGiftStateNow(
          form: event.form,
          giftReceive: event.giftReceive,
          giftReceived: [
            ...event.giftReceived,
            ...[event.gift],
          ],
          giftSBReceived: event.giftSBReceived,
          giftAt: event.giftAt);
    }
    if (event is ReceiveGiftResult) {
      List<GiftEntity> gifts = [];
      List<GiftEntity> giftReceived = event.receiveGiftEntity.gifts;
      // gift had in list
      giftReceived.forEach((element) {
        if(gifts.isEmpty){
          gifts.add(element);
        }else{
          final listID = gifts.map((e) => e.giftId).toList();
          if(listID.contains(element.giftId)){
            int index = listID.indexOf(element.giftId);
            gifts[index] = gifts[index].upReceive();
          }else{
            gifts.add(element);
          }
        }
      });
      print("setCurrent final: $setCurrent");
      yield ReceiveGiftStateResult(
          receiveGiftEntity: ReceiveGiftEntity(
            customer: event.receiveGiftEntity.customer,
            voucher: event.receiveGiftEntity.voucher,
            products: event.receiveGiftEntity.products,
            gifts: gifts,
            voucherReceived: gifts.firstWhere((element) => element is Voucher, orElse: () => Voucher(amountReceive: 0)).amountReceive,
            outletCode: event.receiveGiftEntity.outletCode,
            productImage: event.receiveGiftEntity.productImage,
            customerImage: event.receiveGiftEntity.customerImage,
            receiptImage: event.receiveGiftEntity.receiptImage,
      ));
    }
    if (event is ReceiveGiftSubmit) {
      localData.cacheSetGiftCurrent(setGiftEntity: setCurrent);
      final finish = await handleReceiveGift(HandleReceiveGiftParams(
          receiveGiftEntity: event.receiveGiftEntity, setCurrent: setCurrent));
      yield finish.fold((fail) {
        if (fail is UnAuthenticateFailure) {
          authenticationBloc.add(ShutDown(willPop: 1));
          return null;
        }
        if (fail is InternalFailure) {
          dashboardBloc.add(InternalServer());
          return null;
        }
        return null;
      }, (r) {
        print(r);
        return null;
      });
    }
  }

  List<ProductEntity> merge(List<ProductEntity> products) {
    int heineken, tiger, strongbow, normal;
    heineken = tiger = strongbow = normal = 0;
    products.forEach((element) {
      if (element is Heineken)
        heineken += element.buyQty;
      if (element is Tiger)
        tiger += element.buyQty;
      if (element is StrongBow)
        strongbow += element.buyQty;
      if (element is NormalBeer)
        normal += element.buyQty;
    });
    List<ProductEntity> result = [];
    if (heineken > 0) result.add(Heineken.internal(heineken));
    if (tiger > 0) result.add(Tiger.internal(tiger));
    if (strongbow > 0) result.add(StrongBow.internal(strongbow));
    if (normal > 0) result.add(NormalBeer.internal(normal));

    return result;
  }
}

Stream<ReceiveGiftState> _eitherValidateToState(
    Either<Failure, FormEntity> either) async* {
  yield either.fold((l) {
    if (l is NoImageFailure) return NoImage();
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
      dashboardBloc.add(InternalServer());
      return null;
    }
    return UseVoucherFailure();
  },
      (voucher) => voucher.qty > 0
          ? UseVoucherSuccess(voucher: voucher)
          : UseVoucherFailure());
}

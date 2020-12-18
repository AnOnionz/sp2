import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_gift_usecase.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_wheel_usecase.dart';

part 'receive_gift_event.dart';
part 'receive_gift_state.dart';

class ReceiveGiftBloc extends Bloc<ReceiveGiftEvent, ReceiveGiftState> {
  final DashBoardLocalDataSource local;
  final HandleGiftUseCase handleGift;
  final HandleWheelUseCase handleWheel;
  SetGiftEntity setCurrent;
  ReceiveGiftBloc({this.handleWheel, this.handleGift, this.local})
      : super(ReceiveGiftFormStateInitial());

  @override
  Stream<ReceiveGiftState> mapEventToState(
    ReceiveGiftEvent event,
  ) async* {
    if (event is ReceiveGiftSubmitForm) {
      setCurrent = local.fetchSetGiftCurrent();
      print('setLocal: $setCurrent');
      yield ReceiveGiftPopup(form: event.form);
    }
    if (event is ReceiveGiftConfirm) {
      yield ReceiveGiftHandling(form: event.form);
      CustomerEntity customer = CustomerEntity(
          name: event.form.name,
          phoneNumber: event.form.phoneNumber,
          inTurn: 5);
      final gifts = await handleGift(HandleGiftParams(
          products: merge(event.form.products), customer: customer, setCurrent: setCurrent));
      yield gifts.fold((l) => ReceiveGiftFailure(), (result) {
        print('setCurrent after receive now: ${result.setCurrent}');
        setCurrent = result.setCurrent;
        return ReceiveGifShowTurn(
            customer: customer,
            products: event.form.products,
            takeProductImg: event.form.images,
            gifts: result.gifts,
            message: "Hôm nay bạn có 5 lượt nhận quà");
      });
    }
    if (event is GiftNext) {
      if (event.giftAt == event.giftReceive.length) {
       add(ReceiveGiftResult(gifts: event.giftReceived, customer: event.customer, products: event.products, takeProductImg: event.takeProductImg,));
      } else {
        if (event.giftReceive.elementAt(event.giftAt) is Wheel) {
          final lucky = await handleWheel(HandleWheelParams(
              giftReceived: event.giftReceived, setCurrent: setCurrent));
          yield lucky.fold((l) => ReceiveGiftFailure(message: "error"),
              (result) {
            print('setCurrent after wheel: ${result.setCurrent}');
            setCurrent = result.setCurrent;
            return ReceiveGiftStateWheel(
                customer: event.customer,
                products: event.products,
                takeProductImg: event.takeProductImg,
                giftLucky: result.lucky,
                giftReceive: event.giftReceive,
                giftReceived: event.giftReceived,
                giftAt: event.giftAt);
          });
        } else {
          if (event.giftReceive.elementAt(event.giftAt) is GiftEntity) {
            yield ReceiveGiftStateNow(
                customer: event.customer,
                products: event.products,
                takeProductImg: event.takeProductImg,
                giftReceive: event.giftReceive,
                giftReceived: [
                  ...event.giftReceived,
                  ...[event.giftReceive[event.giftAt]],
                ],
                giftAt: event.giftAt);
          }
        }
      }
    }
    if (event is ShowGiftWheel) {
      setCurrent = SetGiftEntity(index: setCurrent.index, gifts: setCurrent.gifts.map((e) => event.gift.giftId == e.giftId ? e.downCurrent() : e).toList());
      yield ReceiveGiftStateNow(
          customer: event.customer,
          products: event.products,
          takeProductImg: event.takeProductImg,
          giftReceive: event.giftReceive,
          giftReceived: [
            ...event.giftReceived,
            ...[event.gift],
          ],
          giftAt: event.giftAt);
    }
    if (event is ReceiveGiftResult) {
      List<GiftEntity> gifts = [];
      List<GiftEntity> giftReceived = event.gifts;
      // gift da co trong list
      giftReceived.forEach((element) {
        if(gifts.contains(element)){
          gifts[gifts.indexOf(element)] = element.upReceive();
        }else{
          gifts.add(element);
        }
      });
      print("setCurrent final: $setCurrent");
      yield ReceiveGiftStateResult(
        customer: event.customer,
        products: event.products,
        gifts: gifts,
        takeProductImg: event.takeProductImg,
      );

    }
    if(event is ReceiveGiftSubmit){
      local.cacheSetGiftCurrent(setGiftEntity: setCurrent);
    }
  }

  List<ProductEntity> merge(List<ProductEntity> products) {
    int heineken, tiger, strongbow, normal;
    heineken = tiger = strongbow = normal = 0;
    products.forEach((element) {
      if (element is Heineken)
        heineken += int.parse(
            element.controller.text.isEmpty ? '0' : element.controller.text);
      if (element is Tiger)
        tiger += int.parse(
            element.controller.text.isEmpty ? '0' : element.controller.text);
      if (element is StrongBow)
        strongbow += int.parse(
            element.controller.text.isEmpty ? '0' : element.controller.text);
      if (element is NormalBeer)
        normal += int.parse(
            element.controller.text.isEmpty ? '0' : element.controller.text);
    });
    List<ProductEntity> result = [];
    if (heineken > 0) result.add(Heineken.internal(heineken));
    if (tiger > 0) result.add(Tiger.internal(tiger));
    if (strongbow > 0) result.add(StrongBow.internal(strongbow));
    if (normal > 0) result.add(NormalBeer.internal(normal));

    return result;
  }

  @override
  void onTransition(Transition<ReceiveGiftEvent, ReceiveGiftState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}

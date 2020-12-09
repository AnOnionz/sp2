import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/usecase_handle_gift.dart';

part 'receive_gift_event.dart';
part 'receive_gift_state.dart';

class ReceiveGiftBloc extends Bloc<ReceiveGiftEvent, ReceiveGiftState> {
  final UseCaseHandleGift handleGift;
  ReceiveGiftBloc({this.handleGift}) : super(ReceiveGiftForm(form: FormEntity(products: <ProductEntity>[
    Heneiken(brandId: 1, productId: 1,productName: "Heneiken", count: 10, imgUrl: "", price: 10000),
    Heneiken0(brandId: 1, productId: 1,productName: "Heneiken 0.0", count: 10, imgUrl: "", price: 10000),
    HeneikenSilver(brandId: 1, productId: 1,productName: "Heineken Silver", count: 10, imgUrl: "", price: 10000),
    Tiger(brandId: 1, productId: 1,productName: "Tiger", count: 10, imgUrl: "", price: 10000),
    TigerCrystal(brandId: 1, productId: 1,productName: "TigerCrystal", count: 10, imgUrl: "", price: 10000),
    BiaViet(brandId: 1, productId: 1,productName: "BiaViet", count: 10, imgUrl: "", price: 10000),
    Larue(brandId: 1, productId: 1,productName: "Larue", count: 10, imgUrl: "", price: 10000),
    Bivina(brandId: 1, productId: 1,productName: "Bivina", count: 10, imgUrl: "", price: 10000),
    StrongBow(brandId: 1, productId: 1,productName: "StrongBow", count: 10, imgUrl: "", price: 10000)
  ], name: "abc", phoneNumber: "090009909", images: [], isCheckedVoucher: false, voucher: "")));

  @override
  Stream<ReceiveGiftState> mapEventToState(
    ReceiveGiftEvent event,
  ) async* {
    if(event is SubmitForm){

    }
    if(event is Confirm){
      List<ProductEntity> listProductMerged = merge(event.form.products);
      final giftsFinal = await handleGift(HandleGiftParams(products: listProductMerged, customer: CustomerEntity(phoneNumber: '0988880988', name: "a", inTurn: 3)));
    }

  }
  List<ProductEntity> merge(List<ProductEntity> products){
    int heineken = 0;
    int tiger = 0;
    int strongbow = 0;
    int normal = 0;
    products.forEach((element) {
      if (element is Heneiken)
        heineken += int.parse(element.controller.text.isEmpty ? '0' : element.controller.text);
      if (element is Tiger)
        tiger += int.parse(element.controller.text.isEmpty ? '0' : element.controller.text);
      if(element is StrongBow)
        strongbow += int.parse(element.controller.text.isEmpty ? '0' : element.controller.text);
      if(element is NormalBeer)
        normal += int.parse(element.controller.text.isEmpty ? '0' : element.controller.text);
    });
    List<ProductEntity> result = [];
    if(heineken > 0) products.add(Heneiken.internal(heineken));
    if(tiger > 0) products.add(Tiger.internal(tiger));
    if(strongbow > 0) products.add(StrongBow.internal(strongbow));
    if(normal > 0) products.add(NormalBeer.internal(normal));

    return result;
  }

}

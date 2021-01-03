part of 'receive_gift_bloc.dart';

@immutable
abstract class ReceiveGiftState {
  ReceiveGiftState();
  Map<String, dynamic> toJson();

  factory ReceiveGiftState.fromJson(Map<String, dynamic> json){
    return null;
  }
}
// useVoucher
class UseVoucherLoading extends ReceiveGiftState{
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
class UseVoucherSuccess extends ReceiveGiftState {
  final VoucherEntity voucher;

  UseVoucherSuccess({this.voucher});
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

}
class UseVoucherFailure extends ReceiveGiftState {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

}
// form
class FormError extends ReceiveGiftState{
  final String message;

  FormError({this.message});

  @override
  Map<String, dynamic> toJson() {
    return{};
  }

}
class NoImage extends ReceiveGiftState{
  final String message;

  NoImage({this.message});

  @override
  Map<String, dynamic> toJson() {
    return{};
  }

}

class ReceiveGiftFormStateInitial extends ReceiveGiftState {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class ReceiveGiftPopup extends ReceiveGiftState {
  final FormEntity form;

  ReceiveGiftPopup({this.form});

  @override
  Map<String, dynamic> toJson() {
    return form.toJson();
  }
}

class ReceiveGiftHandling extends ReceiveGiftState {
  final FormEntity form;

  ReceiveGiftHandling({this.form});

  @override
  Map<String, dynamic> toJson() {
    return form.toJson();
  }

}

class ReceiveGiftFailure extends ReceiveGiftState {
  final String message;

  ReceiveGiftFailure({this.message});

  @override
  Map<String,dynamic> toJson() {
    return {};
  }
}

class ReceiveGifShowTurn extends ReceiveGiftState {
  final FormEntity form;
  final List<Gift> gifts;
  final String message;
  final SetGiftEntity setCurrent;
  final int type;

  ReceiveGifShowTurn({this.type, this.setCurrent, this.form, this.gifts, this.message});

  @override
  Map<String,dynamic> toJson() {
   return {
     "name": "ShowTurn",
     'customer': form.customer.toJson(),
     'setCurrent': setCurrent,
     'products': form.products.map((e) => {"id": e.productId, "buyQty": e.buyQty}).toList(),
     'gifts': gifts.map((e) => {"id": e.id}).toList(),
     'productImg': form.images.map((e) =>
        e.path).toList(),
     "message": message,
     'type': type
   };
  }

  @override
  String toString() {
    return 'ReceiveGifShowTurn{form: $form, gifts: $gifts, message: $message, type: $type}';
  }
}
// GiftEntity
class ReceiveGiftStateNow extends ReceiveGiftState {
  final FormEntity form;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final List<GiftEntity> giftSBReceived;
  final int giftAt;

  ReceiveGiftStateNow({this.form, this.giftReceive, this.giftReceived, this.giftSBReceived, this.giftAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": "Now",
      'customer': form.customer.toJson(),
      'products': form.products.map((e) => {"id": e.productId, "buyQty": e.buyQty}).toList(),
      'giftReceive': giftReceive.map((e) => {"id": e.id}).toList(),
      'productImg': form.images.map((e) => e.path).toList(),
      "giftReceived": giftReceived.map((e) => {"id": e.id, "qty": e.amountReceive}).toList(),
      'giftSBReceived': giftSBReceived.map((e) => {"id": e.id, "qty": e.amountReceive}).toList(),
    };
  }

  @override
  String toString() {
    return 'ReceiveGiftStateNow{form: $form, giftReceive: $giftReceive, giftReceived: $giftReceived, giftSBReceived: $giftSBReceived, giftAt: $giftAt}';
  }
}

// Wheel
class ReceiveGiftStateWheel extends ReceiveGiftState {
  final FormEntity form;
  final List<GiftEntity> giftLucky; // gift se nhan trong vong quay
  final List<Gift> giftReceive; // gift se nhan toan bo activity
  final List<GiftEntity> giftReceived; // gift da nhan
  final List<GiftEntity> giftSBReceived; // gift strong bow da nhan
  final int giftAt;

  ReceiveGiftStateWheel({this.form, this.giftLucky, this.giftReceive, this.giftSBReceived, this.giftReceived, this.giftAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': "Wheel",
      'customer': form.customer.toJson(),
      'products': form.products.map((e) => {"id": e.productId, "buyQty": e.buyQty}).toList(),
      'giftReceive': giftReceive.map((e) => {"id": e.id}).toList(),
      'productImg': form.images.map((e) => e.path).toList(),
      'giftLucky': giftLucky.map((e)=> {"id": e.id}).toList(),
      'giftReceived': giftReceived.map((e) => {"id": e.id, "qty": e.amountReceive}).toList(),
      'giftSBReceived': giftSBReceived.map((e) => {"id": e.id, "qty": e.amountReceive}).toList(),
      'giftAt': giftAt,
    };
  }

  @override
  String toString() {
    return 'ReceiveGiftStateWheel{form: $form, giftLucky: $giftLucky, giftReceive: $giftReceive, giftReceived: $giftReceived, giftSBReceived: $giftSBReceived, giftAt: $giftAt}';
  }
}
class ReceiveGiftStateSBWheel extends ReceiveGiftState {
  final FormEntity form;
  final List<GiftEntity> giftLucky; // gift se nhan trong vong quay
  final List<Gift> giftReceive; // gift se nhan toan bo activity
  final List<GiftEntity> giftReceived; // gift da nhan
  final List<GiftEntity> giftSBReceived; // gift strong bow da nhan
  final int giftAt;

  ReceiveGiftStateSBWheel({this.form, this.giftLucky, this.giftReceive, this.giftSBReceived, this.giftReceived, this.giftAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': "SBWheel",
      'customer': form.customer.toJson(),
      'products': form.products.map((e) => {"id": e.productId, "buyQty": e.buyQty}).toList(),
      'giftReceive': giftReceive.map((e) => {"id": e.id}).toList(),
      'productImg': form.images.map((e) => e.path).toList(),
      'giftLucky': giftLucky.map((e)=> {"id": e.id}).toList(),
      'giftReceived': giftReceived.map((e) => {"id": e.id, "qty": e.amountReceive}).toList(),
      'giftSBReceived': giftSBReceived.map((e) => {"id": e.id, "qty": e.amountReceive}).toList(),
      'giftAt': giftAt,
    };
  }

  @override
  String toString() {
    return 'ReceiveGiftStateSBWheel{form: $form, giftLucky: $giftLucky, giftReceive: $giftReceive, giftReceived: $giftReceived, giftSBReceived: $giftSBReceived, giftAt: $giftAt}';
  }
}

// Result
class ReceiveGiftStateResult extends ReceiveGiftState {
  final ReceiveGiftEntity receiveGiftEntity;

  ReceiveGiftStateResult({this.receiveGiftEntity});

  @override
  Map<String, dynamic> toJson() {
    return receiveGiftEntity.toJson();
  }

  @override
  String toString() {
    return 'ReceiveGiftStateResult{receiveGiftEntity: $receiveGiftEntity}';
  }
}

class ReceiveGiftNotCondition extends ReceiveGiftState{
  @override
  Map<String,dynamic> toJson() {
   return {};
  }
}
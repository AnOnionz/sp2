import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
// ignore: must_be_immutable
abstract class Failure extends Equatable{
    String message ;
    Failure(mess) : message = mess;

    @override
  String toString() {
    return '$message';
  }
    @override
  List<Object> get props => [message];
}
// ignore: must_be_immutable
class CheckInNullFailure extends Failure{
  CheckInNullFailure({message}): super(message);
}
// ignore: must_be_immutable
class CheckOutNullFailure extends Failure{
  CheckOutNullFailure(): super("Bạn chưa chấm công ra");
}
// ignore: must_be_immutable
class HighLightNullFailure extends Failure{
  HighLightNullFailure(): super("Thông tin cuối ngày chưa đầy đủ");
}
// ignore: must_be_immutable
class InventoryNullFailure extends Failure{
  InventoryNullFailure(): super("Thông tin tồn kho chưa đầy đủ");
}

// ignore: must_be_immutable
class InternalFailure extends Failure{
  InternalFailure(): super("Đã xảy ra lỗi ngoài ý muốn");

}
// ignore: must_be_immutable
class UnAuthenticateFailure extends Failure{
  UnAuthenticateFailure(): super("Phiên đăng nhập đã hết hạn ");

}
// ignore: must_be_immutable
class ResponseFailure extends Failure{
  ResponseFailure({message}): super(message);
}
// ignore: must_be_immutable
class FailureAndCachedToLocal extends Failure{
  FailureAndCachedToLocal({message}): super(message);
}

// ignore: must_be_immutable
class HasSyncFailure extends Failure{
  HasSyncFailure({message}) : super(message);
}
// ignore: must_be_immutable
class InternetFailure extends Failure{
  InternetFailure() : super("Kết nối mạng không ổn định, vui lòng kiểm tra lại");
}
// ignore: must_be_immutable
class SetOverFailure extends Failure{
  SetOverFailure() : super("set over");
}
// ignore: must_be_immutable
class NoImageFailure extends Failure{
  NoImageFailure({message}) : super(message);
}
// ignore: must_be_immutable
class ValueFailure extends Failure{
  ValueFailure() : super("Vui lòng nhập số lượng bia khách mua");
}
// ignore: must_be_immutable
class ContentFailure extends Failure{
  ContentFailure({message}) : super(message);
}
// ignore: must_be_immutable
class PhoneFailure extends Failure{
  PhoneFailure({message}) : super("Số điện thoại không hợp lệ");

}
// ignore: must_be_immutable
class NameFailure extends Failure{
  NameFailure() : super("Vui lòng nhập tên khách hàng");

}


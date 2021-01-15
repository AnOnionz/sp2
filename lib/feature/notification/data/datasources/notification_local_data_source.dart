import 'dart:async';

import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';

abstract class NotificationLocalDataSource {
  Stream<int> get notify;
  Future<void> cacheNotification({FcmEntity fcm});
  int numberOfNotify();
  void seenAll();

}
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource{
  StreamController<int> _controller = StreamController<int>.broadcast();
  @override
  Future<void> cacheNotification({FcmEntity fcm}) async {
   Box<FcmEntity> box = Hive.box<FcmEntity>(AuthenticationBloc.outlet.id.toString() + NOTIFICATION_BOX);
   await box.add(fcm);
   print(box.values.toList());
   _controller.sink.add(numberOfNotify());
  }
  @override
  int numberOfNotify() {
  Box<FcmEntity> box = Hive.box<FcmEntity>(AuthenticationBloc.outlet.id.toString() + NOTIFICATION_BOX);
  return box.values.toList().where((element) => element.isClick == false).length;
}

  @override
  void seenAll() {
    Box<FcmEntity> box = Hive.box<FcmEntity>(AuthenticationBloc.outlet.id.toString() + NOTIFICATION_BOX);
    List<FcmEntity> fcms = box.values.toList();
    for(FcmEntity fcm in fcms){
      fcm.isClick = true;
      fcm.save();
    }
    _controller.sink.add(numberOfNotify());
  }

  @override
  Stream<int> get notify => _controller.stream;

}
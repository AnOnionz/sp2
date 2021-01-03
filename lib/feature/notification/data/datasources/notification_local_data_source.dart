import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';

abstract class NotificationLocalDataSource {
  Future<void> cacheNotification({FcmEntity fcm});

}
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource{
  @override
  Future<void> cacheNotification({FcmEntity fcm}) async {
   Box<FcmEntity> box = Hive.box<FcmEntity>(NOTIFICATION_BOX);
   await box.add(fcm);
  }


}
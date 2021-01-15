import 'package:sp_2021/feature/notification/data/datasources/notification_local_data_source.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';

import '../../di.dart';

class NotifyManager{
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      if (message.containsKey('data')) {
        final dynamic data = message['data'];
        FcmEntity fcm = FcmEntity(
          title: '${notification['notification']['title'] ?? "Thông báo"}',
          body: '${notification['notification']['body'] ?? "Nội dung..."}',
          time: DateTime.now(),
          tab: data['data']['tab'] !=null ? int.parse(data['data']['tab']): null,
          screen: data['data']['screen'],
          isClick: true,
        );
        // Or do other work.
      }
    }

  }
}
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

import '../../di.dart';

abstract class MyDateTime{
  static DateTime day;
  static String today;
  static Future<int> get ntpTime async {
    DateTime _day;
    try{
      _day = await NTP.now();
      sl<SharedPreferences>().setString(TODAY, _day.millisecondsSinceEpoch.toString());
      today = DateFormat.yMd().format(_day).replaceAll("/", "0");
      day = _day;
    }catch(e){
      final todayStr = sl<SharedPreferences>().getString(TODAY);
      if(todayStr != null && DateTime.now().millisecondsSinceEpoch < int.parse(todayStr)){
        _day = DateTime.fromMillisecondsSinceEpoch(int.parse(todayStr));
      } else{
        _day = DateTime.now();
      }
      today = DateFormat.yMd().format(_day).replaceAll("/", "0");
      day = _day;
    }
    return _day.millisecondsSinceEpoch;
  }


}
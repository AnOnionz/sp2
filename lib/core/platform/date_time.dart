import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';

import '../../di.dart';

abstract class MyDateTime{

  static String today;
  static int ntpTime;


  static Future<bool> get earlyTime async {
    DateTime _day;
    try{
     _day = await NTP.now();

    }catch(e){
      _day = DateTime.now();
    }
    final end = int.parse(AuthenticationBloc.outlet.end.toString().replaceAll(":", ""));
    final now = int.parse('${_day.hour}${_day.minute}');
    return now < end;
  }
  static Future<void> timeStart() async {
    DateTime _day;
    try{
      _day = await NTP.now();
      sl<SharedPreferences>().setString(TODAY, _day.millisecondsSinceEpoch.toString());
      today = DateFormat.yMd().format(_day).replaceAll("/", "0");
      ntpTime = _day.millisecondsSinceEpoch;
    }catch(e){
      final todayStr = sl<SharedPreferences>().getString(TODAY);
      DateTime td;
      if(todayStr != null && DateTime.now().millisecondsSinceEpoch < int.parse(todayStr)){
        td = DateTime.fromMillisecondsSinceEpoch(int.parse(todayStr));
      } else{
        td = DateTime.now();
      }
      today = DateFormat.yMd().format(td).replaceAll("/", "0");
      ntpTime = td.millisecondsSinceEpoch;
    }
  }
}
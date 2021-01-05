import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sp_2021/core/error/Exception.dart';

class MyDateTime{
  static String today;
  static Future<DateTime> getNow() async {
    return DateTime.now();
//    try{
//      return await NTP.now();
//    } catch(e){
//      return DateTime.now();
//    }
  }
  static Future<DateTime> getToday() async {
    final day = DateTime.now();
    today = DateFormat.yMd().format( DateTime.now()).replaceAll("/", "");
    return day;
//    try {
//      final day = await NTP.now();
//      today = DateFormat.yMd().format(await NTP.now()).replaceAll("/", "");
//      return day;
//  }catch (e){
//      final day = DateTime.now();
//      today = DateFormat.yMd().format( DateTime.now()).replaceAll("/", "");
//      return day;
//    }
  }
}
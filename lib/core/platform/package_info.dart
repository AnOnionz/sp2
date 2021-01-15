 import 'package:package_info/package_info.dart';

class MyPackageInfo {
  static PackageInfo packageInfo;

  void getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                child: const Text(
                  'CÀI ĐẶT',
                  style: header,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ứng dụng",style: Subtitle1white,),
                        Text("SP", style: Subtitle1white,),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phiên bản", style: Subtitle1white,),
                        Text("1.0.1", style: Subtitle1white,),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 25.0),
                    child: Text("Ứng dụng được phát triển bởi IMARK", style: Subtitle1white,),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text("Đăng xuất", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

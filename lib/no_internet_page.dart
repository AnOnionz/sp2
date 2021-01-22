import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/text_styles.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback retry;

  const NoInternetPage({Key key, this.retry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: FlareActor("assets/images/no_internet.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "init"),
            ),
            Text("Không có kết nối mạng", style: TextStyle(color: Colors.white, fontSize: 20,),),
            Text("Vui lòng kiểm tra kết nối mạng của bạn và thử lại", style: TextStyle(color: Colors.white70, fontSize: 15),),
            retry != null ? FlatButton(
              padding: const EdgeInsets.all(8.0),
              onPressed: retry,
              color: Colors.lightBlueAccent,
              child: Text("Thử lại", style: Subtitle1white,),
            ): Container(),
          ],
        ),
    );
  }
}

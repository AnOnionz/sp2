import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:package_info/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';

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
                        Text(
                          "Ứng dụng",
                          style: Subtitle1white,
                        ),
                        Text(
                          "SP",
                          style: Subtitle1white,
                        ),
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
                        Text(
                          "Phiên bản",
                          style: Subtitle1white,
                        ),
                        Text(
                          "1.0.1",
                          style: Subtitle1white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 25.0),
                    child: Text(
                      "Ứng dụng được phát triển bởi IMARK",
                      style: Subtitle1white,
                    ),
                  ),
                  BlocConsumer<LoginBloc, LoginState>(
                    builder: (context, state) => InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                            title: Text("Đăng xuất ?"),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Bạn có chắc muốn đăng xuất ?", style: Subtitle1black,),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text("Hủy"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                textStyle: TextStyle(color: Colors.red),
                                child: Text("Đăng xuất"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  BlocProvider.of<LoginBloc>(context)
                                      .add(LogoutButtonPress());
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            "Đăng xuất",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    listener: (context, state) {
                      if (state is LogoutCloseDialog) {
                        Navigator.pop(context);
                      }
                      if (state is LogoutLoading) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              content: Column(
                                children: [
                                  CupertinoActivityIndicator(radius: 17, animating: true,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Đang đăng xuất ...", style: Subtitle1black,),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                      if (state is LogoutFailure) {
                        Navigator.pop(context);
                        Dialogs().showFailureDialog(context: context, content: state.message, reTry: (){
                          Navigator.pop(context);
                          BlocProvider.of<LoginBloc>(context)
                              .add(LogoutButtonPress());
                        });
                      }
                      if (state is LogoutSuccess) {
                        Navigator.pop(context);
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                      }

                    },
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

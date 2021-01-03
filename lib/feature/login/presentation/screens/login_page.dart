
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';

class LoginPage extends StatefulWidget {
  final String deviceId;

  LoginPage({Key key, this.deviceId}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController ctlUserName = !kDebugMode ? TextEditingController() : TextEditingController(text: 'sp');
  TextEditingController passWordController = !kDebugMode ? TextEditingController() : TextEditingController(text: '123456');
  bool _obscureText = true;
  final focus = FocusNode();

  openSettingsMenu(settingsName) async {
    var resultSettingsOpening = false;
    try {
      resultSettingsOpening =
      await AccessSettingsMenu.openSettings(settingsType: settingsName);
    } catch (e) {
      resultSettingsOpening = false;
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focus.dispose();
    passWordController.dispose();
    ctlUserName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset('assets/images/Logo HNK - VN_White 2.png',width: 150,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(70, 50, 70, 50),
                child: const Text(
                  'SP FESTIVE 2020-2021',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  controller: ctlUserName,
                  decoration: InputDecoration(
                    hintText: 'Tài khoản',
                    contentPadding: EdgeInsets.all(16),
                    filled: true,
                    fillColor: Color(0xffeaeaea),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffeaeaea)),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      borderSide: BorderSide(color: Color(0xffeaeaea)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      gapPadding: double.infinity,
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(50, 0, 0, 10),
                        child: TextFormField(
                          focusNode: focus,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureText,
                          controller: passWordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
                            contentPadding: EdgeInsets.all(16),
                            filled: true,
                            fillColor: Color(0xffeaeaea),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffeaeaea)),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                              ),
                              borderSide: BorderSide(color: Color(0xffeaeaea)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7),
                              ),
                              gapPadding: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _toggle,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(right: 50),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                        decoration: BoxDecoration(
                          color: Color(0xffeaeaea),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocListener<LoginBloc, LoginState>(
                listenWhen: (previous, current) => true,
                listener: (context, state) {
                  if(state is LoginNoInternet){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => ZoomIn(
                          duration: Duration(milliseconds: 100),
                          child: CupertinoAlertDialog(
                            title: Text("Thông báo"),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Không có kết nối Internet"),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                  isDefaultAction: true,
                                  textStyle:
                                  TextStyle(color: Colors.red),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Hủy")),
                              CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    openSettingsMenu('ACTION_WIRELESS_SETTINGS');
                                  },
                                  child: Text("Cài đặt")),
                            ],
                          ),
                        ));
                  }
                  if(state is LoginInternalServer){
                    Dialogs().showFailureDialog(
                      context: context,
                      content: state.message,
                      reTry: () async {
                        await Future.delayed(
                            const Duration(milliseconds: 500), () => 42);
                        BlocProvider.of<LoginBloc>(context).add(
                            LoginButtonPress(username: ctlUserName.text,
                                password: passWordController.text,
                                deviceId: widget.deviceId));
                        print("login");
                      }
                    );
                  }
                  if (state is LoginFailure) {
                    print("error login");
                    _scaffoldkey.currentState.removeCurrentSnackBar();
                    _scaffoldkey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('${state.message}'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                  if(state is LoginSuccess){
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(loginEntity: state.user));
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                      if (state is LoginLoading){
                        return Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xffFF2B00),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: ProgressButton(
                        defaultWidget: const Text('Đăng nhập', style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Helvetica-regular',
                            color: Colors.white)),
                        progressWidget: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.transparent),
                        ),
                        borderRadius: 7,
                        color: const Color(0xffFF2B00),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        height: 50,
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                              await Future.delayed(
                              const Duration(milliseconds: 500), () => 42);
                              BlocProvider.of<LoginBloc>(context).add(
                              LoginButtonPress(username: ctlUserName.text,
                                  password: passWordController.text,
                                  deviceId: widget.deviceId));
                          print("login");
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

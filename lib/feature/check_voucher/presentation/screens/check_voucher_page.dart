import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/check_voucher/presentation/blocs/check_voucher_bloc.dart';

import '../../../../di.dart';

class CheckVoucherPage extends StatefulWidget {
  @override
  _CheckVoucherPageState createState() => _CheckVoucherPageState();
}

class _CheckVoucherPageState extends State<CheckVoucherPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();
  CheckVoucherBloc bloc;
  @override
  void initState() {
    bloc = sl<CheckVoucherBloc>();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                          child: const Text(
                            'LỊCH SỬ SỬ DỤNG MÃ GIẢM GIÁ',
                            style: header,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0, bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Nhập SĐT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 43,
                                            child: InputField(
                                              hint:
                                                  "Nhập SĐT cần kiểm tra lịch sử",
                                              controller: _controller,
                                              onSubmit: (_) {
                                                if (_controller.text.length !=
                                                        10 ||
                                                    !RegExp(r'^0[^01]([0-9]+)')
                                                        .hasMatch(
                                                            _controller.text)) {
                                                  _scaffoldKey.currentState
                                                      .removeCurrentSnackBar();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Số điện thoại không chính xác',
                                                        style: Subtitle1white,
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                                bloc.add(CheckVoucherStart(
                                                    code: _controller.text));
                                              },
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              action: TextInputAction.done,
                                              inputFormatter: <
                                                  TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]'))
                                              ],
                                              inputType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        BlocBuilder<CheckVoucherBloc,
                                            CheckVoucherState>(
                                          cubit: bloc,
                                          builder: (context, state) {
                                            if (state is CheckVoucherLoading) {
                                              return Container(
                                                height: 43,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                              );
                                            }
                                            return InkWell(
                                              onTap: () {
                                                print(_controller.text);
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                if (_controller.text.length !=
                                                        10 ||
                                                    !RegExp(r'^0[^01]([0-9]+)')
                                                        .hasMatch(
                                                            _controller.text)) {
                                                  _scaffoldKey.currentState
                                                      .removeCurrentSnackBar();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Số điện thoại không chính xác',
                                                        style: Subtitle1white,
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return;
                                                }
                                                bloc.add(CheckVoucherStart(
                                                    code: _controller.text));
                                              },
                                              child: Container(
                                                height: 43,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Kiểm tra",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              BlocListener(
                                cubit: bloc,
                                listener: (context, state) {
                                  if (state is CheckVoucherFailure) {
                                    Dialogs().showSuccessDialog(
                                        content: state.message,
                                        context: context);
                                  }
                                },
                                child: BlocBuilder(
                                  cubit: bloc,
                                  builder: (context, state) {
                                    if (state is CheckVoucherSuccess) {
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                  'Mã giảm giá hiện có: ${state.result.qty}', style: Subtitle1white,),
                                            ),
                                            state.result.history.length > 0
                                                ? Expanded(
                                                    flex: 1,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount: state
                                                          .result.history.length,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            color: Colors.black38,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              DateFormat(
                                                                      'hh:mm a dd-MM-yyyy')
                                                                  .format(state
                                                                      .result
                                                                      .history[
                                                                          index]
                                                                      .time)
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 30,
                                                                    right: 30,
                                                                    top: 10,
                                                                    bottom: 20),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Số lượng voucher sử dụng: ${state.result.history[index].qty} (${state.result.history[index].qty * 20000} VNĐ)',
                                                                  style:
                                                                      Subtitle1white,
                                                                ),
                                                                const SizedBox(
                                                                  height: 3,
                                                                ),
                                                                Text(
                                                                  'Tên nhân viên: ${state.result.history[index].spName}',
                                                                  style:
                                                                      Subtitle1white,
                                                                ),
                                                                const SizedBox(
                                                                  height: 3,
                                                                ),
                                                                Text(
                                                                  'Tên outlet: ${state.result.history[index].outletName}',
                                                                  style:
                                                                      Subtitle1white,
                                                                ),
                                                                const SizedBox(
                                                                  height: 3,
                                                                ),
                                                                Text(
                                                                  'Địa chỉ: ${state.result.history[index].address}',
                                                                  style:
                                                                      Subtitle1white,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 200,
                                                          width: 200,
                                                          child: FlareActor(
                                                              "assets/images/no_available.flr",
                                                              alignment: Alignment
                                                                  .center,
                                                              fit: BoxFit.contain,
                                                              animation:
                                                                  "Untitled"),
                                                        ),
                                                        Text(
                                                          "Mã giảm giá này không tồn tại hoặc chưa được sử dụng",
                                                          style: Subtitle1white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Text(MyPackageInfo.packageInfo.version)),
                ],
              ),
            ),
          ),
        ));
  }
}

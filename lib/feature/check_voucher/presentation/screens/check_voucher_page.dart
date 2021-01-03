import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
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
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                      child: const Text(
                        'KIỂM TRA MÃ GIẢM GIÁ',
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
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 38.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                              "Nhập SĐT cần kiểm tra giảm giá",
                                          controller: _controller,
                                          onSubmit: (_) {
                                            bloc.add(CheckVoucherStart(
                                                code: _controller.text));
                                          },
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          action: TextInputAction.done,
                                          inputType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
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
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Center(
                                              child: CupertinoActivityIndicator(),
                                              ),
                                          );
                                        }
                                        return InkWell(
                                          onTap: () {
                                            print(_controller.text);
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
//                                      if (_controller.text.length != 9 ||
//                                          !RegExp(r'^0[^01]([0-9]+)')
//                                              .hasMatch(_controller.text)) {
//                                        _scaffoldKey.currentState.removeCurrentSnackBar();
//                                        _scaffoldKey.currentState.showSnackBar(
//                                          SnackBar(
//                                            content: Text(
//                                                'Số điện thoại không chính xác.'),
//                                            backgroundColor: Colors.red,
//                                          ),
//                                        );
//                                        return;
//                                      }
                                            bloc.add(CheckVoucherStart(
                                                code: _controller.text));
                                          },
                                          child: Container(
                                            height: 43,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
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
                                Dialogs().showMessageDialog(
                                    content: state.message, context: context);
                              }
                            },
                            child: BlocBuilder(
                              cubit: bloc,
                              builder: (context, state) {
                                if (state is CheckVoucherSuccess) {
                                  return state.history.length > 0
                                      ? Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: state.history.length,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  color: Colors.black38,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    state.history[index].time
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 30,
                                                      right: 30,
                                                      top: 10,
                                                      bottom: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Số lượng voucher sử dụng: ${state.history[index].qty} (${state.history[index].qty * 20000} VNĐ)',
                                                        style: Subtitle1white,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        'Tên nhân viên: ${state.history[index].spName}',
                                                        style: Subtitle1white,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        'Tên outlet: ${state.history[index].outletName}',
                                                        style: Subtitle1white,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        'địa chỉ: ${state.history[index].address}',
                                                        style: Subtitle1white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      )
                                      : Expanded(
                                        child: Center(
                                            child: Text(
                                              "Không tìm thấy",
                                              style: Subtitle1white,
                                            ),
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
            ),
          ),
        ));
  }
}

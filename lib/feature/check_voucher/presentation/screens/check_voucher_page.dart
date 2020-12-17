import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:package_info/package_info.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/feature/check_voucher/domain/entities/voucher_history_entity.dart';
import 'package:sp_2021/feature/check_voucher/presentation/blocs/check_voucher_bloc.dart';

import '../../../../di.dart';

class CheckVoucherPage extends StatefulWidget {
  @override
  _CheckVoucherPageState createState() => _CheckVoucherPageState();
}

class _CheckVoucherPageState extends State<CheckVoucherPage> {
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
    super.dispose();
  }

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
                  'KIỂM TRA MÃ GIẢM GIÁ',
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
                    child: Column(
                      children: [
                        Text(
                          "Nhập SĐT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 43,
                                child: InputField(
                                  controller: _controller,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  action: TextInputAction.done,
                                  inputType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              height: 43,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                "Kiểm tra",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  BlocListener(
                    cubit: bloc,
                    listener: (context, state) {
                      if (state is CheckVoucherFailure) {}
                    },
                    child: BlocBuilder(
                      cubit: bloc,
                      builder: (context, state) {
                        if (state is CheckVoucherSuccess) {
                          return ListView.builder(
                            itemCount: state.history.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Column(
                              children: [
                                Container(
                                  color: Colors.black12,
                                  child: Center(
                                    child: Text(
                                        state.history[index].time.toString()),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
                                  child: Column(
                                    children: [
                                      Text('Số lượng voucher sử dụng: ${state.history[index].qty} (${state.history[index].qty * 10000} VNĐ)'),
                                      Text('Tên nhân viên: ${state.history[index].outlet.srName}'),
                                      Text('Tên outlet: ${state.history[index].outlet.name}'),
                                      Text('địa chỉ: ${state.history[index].outlet.address}'),

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
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: [],
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_form.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_message.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_result.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_sb_wheel.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_wheel.dart';

import '../../../../di.dart';

class ReceiveGiftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ReceiveGiftBloc>(create: (_) => sl<ReceiveGiftBloc>()..add(ReceiveGiftStart())),
        ],
        child: BlocBuilder<ReceiveGiftBloc, ReceiveGiftState>(
          builder: (context, state) {
            if(state is ReceiveGiftStateNow){
              return WillPopScope(
                  onWillPop: () async  => false,
                  child: ReceiveGiftMessagePage(form: state.form, giftAt: state.giftAt, giftReceive: state.giftReceive, giftReceived: state.giftReceived, giftSBReceived: state.giftSBReceived));
            }
            if(state is ReceiveGiftStateWheel){
              return WillPopScope(
                  onWillPop: () async  => false,
                  child: ReceiveGiftWheelPage(form: state.form, giftLucky: state.giftLucky, giftReceive: state.giftReceive, giftReceived: state.giftReceived, giftSBReceived: state.giftSBReceived, giftAt: state.giftAt,));
            }
            if(state is ReceiveGiftStateSBWheel){
              return WillPopScope(
                  onWillPop: () async  => false,
                  child: ReceiveGiftSBWheelPage(form: state.form, giftLucky: state.giftLucky, giftReceive: state.giftReceive, giftReceived: state.giftReceived, giftSBReceived: state.giftSBReceived, giftAt: state.giftAt,));
            }
            if(state is ReceiveGiftStateResult){
                return WillPopScope(
                    onWillPop: () async  => false,
                    child:  ReceiveGiftResultPage(entity: state.receiveGiftEntity,));
            }
            return ReceiveGiftFormPage();

          },
        ),
      );
  }
}

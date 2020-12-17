import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_form.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_message.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_result.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_wheel.dart';

import '../../../../di.dart';

class ReceiveGiftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReceiveGiftBloc>(create: (_) => sl<ReceiveGiftBloc>()),
      ],
      child: BlocListener<ReceiveGiftBloc, ReceiveGiftState>(
        listener: (context, state) {

        },
        child: BlocBuilder<ReceiveGiftBloc, ReceiveGiftState>(
          builder: (context, state) {
            if(state is ReceiveGiftStateNow){
              return ReceiveGiftMessagePage(customer: state.customer, products: state.products, takeProductImg: state.takeProductImg, giftAt: state.giftAt, giftReceive: state.giftReceive, giftReceived: state.giftReceived,);
            }
            if(state is ReceiveGiftStateWheel){
              return ReceiveGiftWheelPage(customer: state.customer, products: state.products, takeProductImg: state.takeProductImg,giftLucky: state.giftLucky, giftReceive: state.giftReceive, giftReceived: state.giftReceived, giftAt: state.giftAt,);
            }
            if(state is ReceiveGiftStateResult){
              return ReceiveGiftResultPage(customer: state.customer, gifts: state.gifts, products: state.products,);
            }
            return ReceiveGiftFormPage();

          },
        ),
      ),
    );
  }
}

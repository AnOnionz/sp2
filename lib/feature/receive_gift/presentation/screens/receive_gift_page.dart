import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/screens/receive_gift_form.dart';

import '../../../../di.dart';

class ReceiveGiftPage extends StatelessWidget{
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
            if(state is ReceiveGiftForm){
              return ReceiveGiftFormPage(form: state.form);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
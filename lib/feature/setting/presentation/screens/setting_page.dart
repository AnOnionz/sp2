import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';

import '../../../../di.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: RaisedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            child: Text("Logout"),
            color: Colors.blue,
            padding: EdgeInsets.all(9.0),
            elevation: 4,
          ),
        ),
    );
  }
}

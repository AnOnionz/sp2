import 'package:flutter/material.dart';
import 'package:sp_2021/di.dart';

import 'login/presentation/blocs/authentication_bloc.dart';

class NewDomainPage extends StatefulWidget {
  @override
  _NewDomainPageState createState() => _NewDomainPageState();
}

class _NewDomainPageState extends State<NewDomainPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 450,
              height: 50,
              child: TextFormField(
                controller: _controller,
              ),
            ),
            RaisedButton(onPressed: (){
              //CDio.apiBaseUrl = _controller.text;
              sl<AuthenticationBloc>().add(AppStarted());
            },
              padding: const EdgeInsets.all(8.0),
            child: Text("add"),
            ),
          ],
        ),
      ),
    );
  }
}

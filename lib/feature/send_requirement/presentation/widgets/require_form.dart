import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/send_requirement/presentation/blocs/send_requirement_bloc.dart';

class RequireForm extends StatefulWidget {

  RequireForm({Key key}) : super(key: key);

  @override
  _RequireFormState createState() => _RequireFormState();
}

class _RequireFormState extends State<RequireForm> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:10 , right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Nội dung yêu cầu:",
              style: Subtitle1white,
            ),
          ),
          AutoSizeTextField(
            textInputAction: TextInputAction.done,
            onSubmitted: (_){
              Scaffold.of(context).removeCurrentSnackBar();
              if (controller.text
                  .split('')
                  .where((element) {
                if (element == ".") return true;
                if (element == "!") return true;
                if (element == "|") return true;
                if (element == "@") return true;
                if (element == "'") return true;
                if (element == "=") return true;
                if (element == "/") return true;
                if (element == "+") return true;
                if (element == "-") return true;
                if (element == "%") return true;
                if (element == "*") return true;
                if (element == "&") return true;

                return false;
              })
                  .toList()
                  .length >
                  0 ||
                  controller.text == "") {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Yêu cầu không hợp lệ"),
                  ),
                  backgroundColor: Colors.red,
                ));
                return;
              }
              BlocProvider.of<SendRequirementBloc>(context)
                  .add(SendRequirement(message: controller.text.trim()));
            },
            decoration: InputDecoration(
              hintText: 'Nhập nội dung',
              hintStyle: TextStyle(color: Colors.black45, fontSize: 17),
              contentPadding: const EdgeInsets.all(10.0),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffeaeaea)),
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                borderSide: BorderSide(color: Color(0xffeaeaea)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                gapPadding: double.infinity,
              ),
            ),
            fullwidth: true,
            controller: controller,
            minFontSize: 15,
            maxLines: 4,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(fontSize: 16),
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context)
                  .requestFocus(FocusNode());
              Scaffold.of(context).removeCurrentSnackBar();
              if (controller.text
                          .split('')
                          .where((element) {
                            if (element == ".") return true;
                            if (element == "!") return true;
                            if (element == "|") return true;
                            if (element == "@") return true;
                            if (element == "'") return true;
                            if (element == "=") return true;
                            if (element == "/") return true;
                            if (element == "+") return true;
                            if (element == "-") return true;
                            if (element == "%") return true;
                            if (element == "*") return true;
                            if (element == "&") return true;

                            return false;
                          })
                          .toList()
                          .length >
                      0 ||
                  controller.text == "") {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Yêu cầu không hợp lệ"),
                  ),
                  backgroundColor: Colors.red,
                ));
                return;
              }
              print('a');
              BlocProvider.of<SendRequirementBloc>(context)
                  .add(SendRequirement(message: controller.text.trim()));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: greenCentColor,
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Center(
                  child: Text(
                    "Gửi yêu cầu",
                    style: Subtitle1white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

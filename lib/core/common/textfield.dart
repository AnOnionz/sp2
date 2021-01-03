import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_2021/core/common/text_styles.dart';

@immutable
// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final Function onSubmit;
  final String subText;
  final bool enable;
  final String hint;
  final FocusNode thisFocus;
  final FocusNode nextFocus;
  final TextInputAction action;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final TextAlign textAlign;
  final List inputFormatter;

  const InputField({Key key,this.enable = true, this.onSubmit, this.subText, this.textAlign, this.controller, this.hint,this.action, this.textCapitalization, this.inputType, this.thisFocus, this.nextFocus, this.inputFormatter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable,
      focusNode: thisFocus,
      textInputAction: action,
      textAlign: textAlign,
      autofocus: false,
      onFieldSubmitted: nextFocus != null ?  (v) {
        FocusScope.of(context).requestFocus(nextFocus);
      }: onSubmit,
      controller: controller,
      style: textInput,
      textCapitalization: textCapitalization,
      keyboardType: inputType,
      inputFormatters: inputFormatter,
      decoration: InputDecoration(
        suffixText: subText,
        suffixStyle: TextStyle(color: Colors.black),
        hintText: hint,
        hintStyle: hintText,
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        filled: true,
        fillColor:enable ? Colors.white : Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffeaeaea)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Color(0xffeaeaea)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Color(0xffeaeaea)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gapPadding: double.infinity,
        ),
      ),
    );
  }
}

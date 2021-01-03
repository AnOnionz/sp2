import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
class RequireForm extends StatelessWidget {
  final VoidCallback onSubmit;
  final TextEditingController controller = TextEditingController();

  RequireForm({Key key, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text("Nội dung yêu cầu:", style: Subtitle1white,),
        ),
        AutoSizeTextField(
          textInputAction: TextInputAction.done,
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
          onTap: onSubmit,
          child: Padding(
            padding: const EdgeInsets.only(
               bottom: 20, top: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: greenCentColor,
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Center(child: Text("Gửi yêu cầu", style: Subtitle1white,),),
            ),
          ),
        ),
      ],
    );
  }
}

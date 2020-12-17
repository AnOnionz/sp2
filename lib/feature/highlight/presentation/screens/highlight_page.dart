import 'dart:io';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';

class HighLightPage extends StatefulWidget {
  @override
  _HighLightPageState createState() => _HighLightPageState();
}

class _HighLightPageState extends State<HighLightPage> {
  List<HighlightEntity> _highlights = [
    HighlightEntity(title: "Những vấn đề gặp phải của buổi làm việc",content: "", images: [], hint: "Chủ outlet không hợp tác, không có chỗ đứng trong outlet, trời mưa nhiều nên không bán được hàng, vắng khách,…"),
    HighlightEntity(title: "Thông tin đối thủ", content: "", images: [], hint: "Đối thủ đang có chương trình khuyến mãi hấp dẫn hơn, Bia SàiGòn đang có chương trình mua 1 thùng tặng thẻ cào 50k,…" ),
    HighlightEntity(title: "Cập nhật hiện trạng POSM", content: "", images: [], hint: "Tốt, standee bị hư hỏng, mất standee,…"),
    HighlightEntity(title: "Cập nhật hiện trạng quà tặng, bia tồn", content: "", images: [], hint: "Tốt, cần thêm quà tặng, đã hết quà,…")
  ];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 60),
                        Text(
                          'THÔNG TIN CUỐI NGÀY',
                          style: header,
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(5),
                              child: Center(
                                child: Text(
                                  'LƯU',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff008319),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
               Expanded(
                 child: ListView.builder(
                   itemCount: _highlights.length,
                   physics: BouncingScrollPhysics(),
                   itemBuilder: (context, index) => Container(
                     padding: EdgeInsets.only(left: 20, right: 20),
                     margin: EdgeInsets.only(bottom: 12.0),
                     height: 200,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(5.0),
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(bottom: 10, top: 12),
                         child: Text(_highlights[index].title, style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w700),),
                       ),
                       Row(crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                         Padding(
                           padding: const EdgeInsets.only(right: 30),
                           child: Text('Nội dung:', style:TextStyle(color: Colors.black, fontSize: 17)),
                         ),
                         Expanded(
                           child: AutoSizeTextField(
                             textInputAction: TextInputAction.done,
                             decoration: InputDecoration(
                               hintText: _highlights[index].hint,
                               contentPadding: const EdgeInsets.all(10.0),
                               filled: true,
                               fillColor: Colors.black.withOpacity(0.1),
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(color: Color(0xffeaeaea)),
                                 borderRadius: BorderRadius.all(Radius.circular(5)),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(5)),
                                 borderSide: BorderSide(color: Color(0xffeaeaea)),
                               ),
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(5)),
                                 gapPadding: double.infinity,
                               ),
                           ),
                             fullwidth: true,
                             controller: _highlights[index].controller,
                             onChanged: (value){
                               _highlights[index] =  _highlights[index].copyWith(content: value);
                             },
                             minFontSize: 15,
                             maxLines: 3,
                             textCapitalization: TextCapitalization.words,
                             style: TextStyle(fontSize: 16),
                           ),
                         )
                       ],),
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.only(top: 10),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                             Padding(
                               padding: const EdgeInsets.only(right: 30),
                               child: Text("Hình ảnh:", style: TextStyle(color: Colors.black, fontSize: 17)),
                             ),
                             Flexible(
                               child: Container(
                                 child: Row(
                                   children: <Widget>[
                                     Material(
                                       borderRadius:
                                       BorderRadius.all(Radius.circular(5)),
                                       child: InkWell(
                                         onTap: ()async {
                                           if ( _highlights[index].images.length < 5) {
                                             final pickedFile = await picker.getImage(
                                                 source: ImageSource.camera, maxWidth: 500, maxHeight: 600);
                                             if (pickedFile != null) {
                                               setState(() {
                                                 _highlights[index].images.add(File(pickedFile.path));
                                               });
                                             }
                                           }
                                         },
                                         borderRadius: BorderRadius.all(
                                             Radius.circular(5)),
                                         child: Container(
                                           height: 50,
                                           width: 50,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(5.0),
                                             border: Border.all(
                                               color: Colors.black.withOpacity(0.4),
                                             ),
                                           ),
                                           padding: const EdgeInsets.all(10),
                                           child: Image.asset(
                                               'assets/images/camera.png', fit:BoxFit.cover,),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 10),
                                     Expanded(
                                       child: Container(
                                         height: 60,
                                         child: ListView(
                                           scrollDirection: Axis.horizontal,
                                           physics: BouncingScrollPhysics(),
                                           children: _highlights[index].images.map((image) {
                                             return GestureDetector(
                                               onTap: () {
                                                 showDialog(
                                                   context: context,
                                                   barrierDismissible: true,
                                                   builder: (BuildContext context) {
                                                     return PreviewImageDialog(
                                                       textButton: 'Xóa',
                                                       image: image,
                                                       onTap: () {
                                                         setState(() {
                                                           _highlights[index].images.remove(image);
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     );
                                                   },
                                                 );
                                               },
                                               child: Container(
                                                 height: 55,
                                                 width: 55,
                                                 margin: _highlights[index].images.indexOf(image) ==
                                                     _highlights[index].images.length - 1
                                                     ? const EdgeInsets.only(
                                                     right: 0)
                                                     : const EdgeInsets.only(
                                                     right: 10),
                                                 child: ClipRRect(
                                                   borderRadius:
                                                   BorderRadius.all(
                                                       Radius.circular(5)),
                                                   child: Image.file(image,
                                                       fit: BoxFit.cover),
                                                 ),
                                               ),
                                             );
                                           }).toList(),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           ],),
                         ),
                       ),
                     ],
                   ),
                 ), ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

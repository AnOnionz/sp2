import 'dart:io';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';
import 'package:sp_2021/feature/highlight/presentation/blocs/highlight_bloc.dart';
import 'package:sp_2021/feature/highlight/presentation/widgets/save_button.dart';

import '../../../../di.dart';

class HighLightPage extends StatefulWidget {
  @override
  _HighLightPageState createState() => _HighLightPageState();
}

class _HighLightPageState extends State<HighLightPage> {
  final picker = ImagePicker();
  List<HighlightEntity> _highlights;

@override
void initState() {
  super.initState();
  final dataToday = sl<DashBoardLocalDataSource>().dataToday;
  _highlights = <HighlightEntity>[
    HighlightEntity(title: "Những vấn đề gặp phải của buổi làm việc", content: dataToday.highlightCached != null ? dataToday.highlightCached.workContent : "", images: dataToday.highlightCached != null ? dataToday.highlightCached.workImages.map((e) => File(e)).toList() : [], hint: "Chủ outlet không hợp tác, không có chỗ đứng trong outlet, trời mưa nhiều nên không bán được hàng, vắng khách,…"),
    HighlightEntity(title: "Thông tin đối thủ", content: dataToday.highlightCached != null ? dataToday.highlightCached.rivalContent : "", images:dataToday.highlightCached != null ? dataToday.highlightCached.rivalImages.map((e) => File(e)).toList() : [], hint: "Đối thủ đang có chương trình khuyến mãi hấp dẫn hơn, Bia SàiGòn đang có chương trình mua 1 thùng tặng thẻ cào 50k,…" ),
    HighlightEntity(title: "Cập nhật hiện trạng POSM", content: dataToday.highlightCached != null ? dataToday.highlightCached.posmContent : "", images:dataToday.highlightCached != null ? dataToday.highlightCached.posmImages.map((e) => File(e)).toList() : [], hint: "Tốt, standee bị hư hỏng, mất standee,…"),
    HighlightEntity(title: "Cập nhật hiện trạng quà tặng, bia tồn", content:  dataToday.highlightCached != null ? dataToday.highlightCached.giftContent : "", images:dataToday.highlightCached != null ? dataToday.highlightCached.giftImages.map((e) => File(e)).toList() : [], hint: "Tốt, cần thêm quà tặng, đã hết quà,…")
  ];
  }

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
            child: BlocProvider<HighlightBloc>(
              create: (context)=> sl<HighlightBloc>(),
              child: BlocListener<HighlightBloc, HighlightState>(
                listener: (context, state) {
                  if(state is HighlightCloseDialog){
                    Navigator.pop(context);
                  }
                  if(state is HighlightLoading){
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: CupertinoActivityIndicator(
                              radius: 20,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is HighlightUpdated) {
                    Navigator.pop(context);
                    Dialogs().showMessageDialog(context: context, content: "Thông tin cuối ngày cập nhật thành công");
                  }
                  if (state is HighlightCached) {
                    Navigator.pop(context);
                    Dialogs().showMessageDialog(context: context, content: "Thông tin cuối ngày đã được lưu lại");
                  }
                  if (state is HighlightFailure) {
                    Navigator.pop(context);
                    Dialogs().showSavedToLocalDialog(content: state.message, context: context);
                  }
                  if(state is HighlightNoContent){
                   Scaffold.of(context).removeCurrentSnackBar();
                   Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.message}'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                  if(state is HighlightNoImage){
                    Scaffold.of(context).removeCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hình ảnh chưa đầy đủ'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 35, 0, 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(width: 60),
                                Text(
                                  'THÔNG TIN CUỐI NGÀY',
                                  style: header,
                                ),
                                SaveButton(highlights: _highlights),
                              ]),
                        ),
                      Expanded(
                               child: ListView.builder(
                                 itemCount: _highlights.length,
                                 physics: BouncingScrollPhysics(),
                                 itemBuilder: (context, index) =>
                                     Container(
                                       padding: EdgeInsets.only(
                                           left: 20, right: 20),
                                       margin: EdgeInsets.only(bottom: 12.0),
                                       height: 200,
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(5.0),
                                       ),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment
                                             .start,
                                         children: [
                                           Padding(
                                             padding: const EdgeInsets.only(
                                                 bottom: 10, top: 12),
                                             child: Text(_highlights[index].title,
                                               style: TextStyle(
                                                   color: Colors.green,
                                                   fontSize: 20,
                                                   fontWeight: FontWeight.w700),),
                                           ),
                                           Row(
                                             crossAxisAlignment: CrossAxisAlignment
                                                 .start,
                                             children: [
                                               Padding(
                                                 padding: const EdgeInsets.only(
                                                     right: 30),
                                                 child: Text('Nội dung:',
                                                     style: TextStyle(
                                                         color: Colors.black,
                                                         fontSize: 17)),
                                               ),
                                               Expanded(
                                                 child: AutoSizeTextField(
                                                   textInputAction: TextInputAction
                                                       .done,
                                                   decoration: InputDecoration(
                                                     hintText: _highlights[index]
                                                         .hint,
                                                     contentPadding: const EdgeInsets
                                                         .all(10.0),
                                                     filled: true,
                                                     fillColor: Colors.black
                                                         .withOpacity(0.1),
                                                     focusedBorder: OutlineInputBorder(
                                                       borderSide: BorderSide(
                                                           color: Color(
                                                               0xffeaeaea)),
                                                       borderRadius: BorderRadius
                                                           .all(
                                                           Radius.circular(5)),
                                                     ),
                                                     enabledBorder: OutlineInputBorder(
                                                       borderRadius: BorderRadius
                                                           .all(
                                                           Radius.circular(5)),
                                                       borderSide: BorderSide(
                                                           color: Color(
                                                               0xffeaeaea)),
                                                     ),
                                                     border: OutlineInputBorder(
                                                       borderRadius: BorderRadius
                                                           .all(
                                                           Radius.circular(5)),
                                                       gapPadding: double
                                                           .infinity,
                                                     ),
                                                   ),
                                                   fullwidth: true,
                                                   controller: _highlights[index]
                                                       .controller
                                                     ..addListener(() {
                                                       _highlights[index]
                                                           .content =
                                                           _highlights[index]
                                                               .controller.text;
                                                     }),
                                                   minFontSize: 15,
                                                   maxLines: 3,
                                                   textCapitalization: TextCapitalization
                                                       .words,
                                                   style: TextStyle(fontSize: 16),
                                                 ),
                                               )
                                             ],),
                                           Expanded(
                                             child: Padding(
                                               padding: const EdgeInsets.only(
                                                   top: 10),
                                               child: Row(
                                                 crossAxisAlignment: CrossAxisAlignment
                                                     .start,
                                                 children: [
                                                   Padding(
                                                     padding: const EdgeInsets
                                                         .only(right: 30),
                                                     child: Text("Hình ảnh:",
                                                         style: TextStyle(
                                                             color: Colors.black,
                                                             fontSize: 17)),
                                                   ),
                                                   Flexible(
                                                     child: Container(
                                                       child: Row(
                                                         children: <Widget>[
                                                           Material(
                                                             borderRadius:
                                                             BorderRadius.all(
                                                                 Radius.circular(
                                                                     5)),
                                                             child: InkWell(
                                                               onTap: () async {
                                                                 if (_highlights[index]
                                                                     .images
                                                                     .length <
                                                                     5) {
                                                                   final pickedFile = await picker.getImage(
                                                                       source: ImageSource.camera, maxWidth: 480, maxHeight: 640);
                                                                   if (pickedFile !=
                                                                       null) {
                                                                     setState(() {
                                                                       _highlights[index]
                                                                           .images
                                                                           .add(
                                                                           File(
                                                                               pickedFile
                                                                                   .path));
                                                                     });
                                                                   }
                                                                 }
                                                               },
                                                               borderRadius: BorderRadius
                                                                   .all(
                                                                   Radius
                                                                       .circular(
                                                                       5)),
                                                               child: Container(
                                                                 height: 50,
                                                                 width: 50,
                                                                 decoration: BoxDecoration(
                                                                   borderRadius: BorderRadius
                                                                       .circular(
                                                                       5.0),
                                                                   border: Border
                                                                       .all(
                                                                     color: Colors
                                                                         .black
                                                                         .withOpacity(
                                                                         0.4),
                                                                   ),
                                                                 ),
                                                                 padding: const EdgeInsets
                                                                     .all(10),
                                                                 child: Image
                                                                     .asset(
                                                                   'assets/images/camera.png',
                                                                   fit: BoxFit
                                                                       .cover,),
                                                               ),
                                                             ),
                                                           ),
                                                           SizedBox(width: 10),
                                                           Expanded(
                                                             child: Container(
                                                               height: 60,
                                                               child: ListView(
                                                                 scrollDirection: Axis
                                                                     .horizontal,
                                                                 physics: BouncingScrollPhysics(),
                                                                 children: _highlights[index]
                                                                     .images.map((
                                                                     image) {
                                                                   return GestureDetector(
                                                                     onTap: () {
                                                                       showDialog(
                                                                         context: context,
                                                                         barrierDismissible: true,
                                                                         builder: (
                                                                             BuildContext context) {
                                                                           return PreviewImageDialog(
                                                                             textButton: 'Xóa',
                                                                             image: image,
                                                                             onTap: () {
                                                                               setState(() {
                                                                                 _highlights[index]
                                                                                     .images
                                                                                     .remove(
                                                                                     image);
                                                                               });
                                                                               Navigator
                                                                                   .pop(
                                                                                   context);
                                                                             },
                                                                           );
                                                                         },
                                                                       );
                                                                     },
                                                                     child: Container(
                                                                       height: 55,
                                                                       width: 55,
                                                                       margin: _highlights[index]
                                                                           .images
                                                                           .indexOf(
                                                                           image) ==
                                                                           _highlights[index]
                                                                               .images
                                                                               .length -
                                                                               1
                                                                           ? const EdgeInsets
                                                                           .only(
                                                                           right: 0)
                                                                           : const EdgeInsets
                                                                           .only(
                                                                           right: 10),
                                                                       child: ClipRRect(
                                                                         borderRadius:
                                                                         BorderRadius
                                                                             .all(
                                                                             Radius
                                                                                 .circular(
                                                                                 5)),
                                                                         child: Image
                                                                             .file(
                                                                             image,
                                                                             fit: BoxFit
                                                                                 .cover),
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
                                     ),),
                             ),
                      ],
                    ),
                ),
                ),
              ),
            ),
          ),
    );
  }
}

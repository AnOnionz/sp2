import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';

class HighlightContainer extends StatefulWidget {
  final HighlightEntity highlightEntity;

  const HighlightContainer({Key key, this.highlightEntity}) : super(key: key);
  @override
  _HighlightContainerState createState() => _HighlightContainerState();
}

class _HighlightContainerState extends State<HighlightContainer> {
  TextEditingController textCtrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    textCtrl = widget.highlightEntity.controller;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(bottom: 12.0),
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
              child: Text(
                widget.highlightEntity.title,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text('Nội dung:',
                      style: TextStyle(color: Colors.black, fontSize: 17)),
                ),
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: widget.highlightEntity.hint,
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
                    controller: textCtrl,
                    onChanged: (value) {
                      widget.highlightEntity.content = value;
                    },
                    maxLines: 3,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text("Hình ảnh:",
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ),
                    Flexible(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: InkWell(
                                onTap: () async {
                                  if (widget.highlightEntity.images.length <
                                      3) {
                                    final pickedFile = await picker.getImage(
                                        source: ImageSource.camera,
                                        maxWidth: 480,
                                        maxHeight: 640);
                                    if (pickedFile != null) {
                                      setState(() {
                                        widget.highlightEntity.images
                                            .add(File(pickedFile.path));
                                      });
                                    }
                                  }
                                },
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                                    'assets/images/camera.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  children: widget.highlightEntity.images
                                      .map((image) {
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
                                                  widget.highlightEntity.images
                                                      .remove(image);
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
                                        margin: widget.highlightEntity.images
                                                    .indexOf(image) ==
                                                widget.highlightEntity.images
                                                        .length -
                                                    1
                                            ? const EdgeInsets.only(right: 0)
                                            : const EdgeInsets.only(right: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

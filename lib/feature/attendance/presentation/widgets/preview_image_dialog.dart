import 'dart:io';

import 'package:flutter/material.dart';
class PreviewImageDialog extends StatefulWidget {
  final File image;
  final VoidCallback onTap;
  final String textButton;

  PreviewImageDialog({@required this.image, this.onTap, @required this.textButton});

  @override
  _PreviewImageDialogState createState() => _PreviewImageDialogState();
}

class _PreviewImageDialogState extends State<PreviewImageDialog> {
  File get _image => widget.image;
  Function get _event => widget.onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(5),
      children: <Widget>[
        Container(
          child: Image.file(
            _image,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          children: <Widget>[
            FlatButton(
              child: Text(
                widget.textButton,
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              onPressed: _event,
            ),
            Spacer(),
            FlatButton(
              child: Text(
                'Đóng',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
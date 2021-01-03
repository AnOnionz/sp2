import 'dart:io';

import 'package:flutter/material.dart';
class ImageButton extends StatelessWidget {
  final File image;
  final Color color;
  final VoidCallback onTap;

  const ImageButton({Key key, this.image, this.color, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Material(
        color: Color(0xff205527)
            .withOpacity(0.38),
        borderRadius:
        BorderRadius.circular(3),
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(3),
          child: image == null
              ? Container(
            width: 60,
            height: 47,
            color: color,
            alignment:
            Alignment.center,
            child: Image.asset(
              "assets/images/camera.png",
              color: Colors.black87,
              width: 30,
            ),
          )
              : ClipRRect(
            borderRadius:
            BorderRadius.circular(
                5),
            child: Image.file(image,
                width: 60,
                height: 47,
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

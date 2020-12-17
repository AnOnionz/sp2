import 'dart:typed_data';
import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/material.dart';

class FutureImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;

  const FutureImage({Key key, this.image, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData>(
      future: ByteDataAssets.instance.load(image),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data.buffer.asUint8List(),width: width, height: height,);
        } else {
          return Text('loading..');
        }
      },
    );
  }
}

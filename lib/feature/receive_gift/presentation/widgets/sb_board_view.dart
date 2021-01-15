import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';


class SBBoardView extends StatefulWidget {
  final double angle;
  final double current;
  final List<GiftEntity> items;

  const SBBoardView({Key key, this.angle, this.current, this.items})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SBBoardViewState();
  }
}

class _SBBoardViewState extends State<SBBoardView> {
  Size get size => Size(MediaQuery.of(context).size.width * 0.8,
      MediaQuery.of(context).size.width * 0.8);

  double _rotote(int index) => (index / widget.items.length) * 2 * pi;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //shadow
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)]),
        ),
        Transform.rotate(
          angle: -(widget.current + widget.angle) * 2 * pi,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              for (var luck in widget.items) ...[_buildCard(luck)],
              for (var luck in widget.items) ...[_buildImage(luck)],
            ],
          ),
        ),
      ],
    );
  }

  _buildCard(GiftEntity gift) {
    var _rotate = _rotote(widget.items.map((e) => e.giftId).toList().indexOf(gift.giftId));
    var _angle = 2 * pi / widget.items.length;
    int indexOf = widget.items.indexOf(gift);
    return Transform.rotate(
      angle: _rotate,
      child: ClipPath(
        clipper: _LuckPath(_angle),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: indexOf % 2 == 0 ? AssetImage("assets/images/vongsb2.png"): AssetImage("assets/images/vongsb1.png"),
                scale: 3.3 //7.3//
            ),
          ),
        ),
      ),
    );
  }

  _buildImage(GiftEntity gift) {
    var _rotate = _rotote(widget.items.indexOf(gift));
    return Transform.rotate(
      angle: _rotate,
      child: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.topCenter,
        child:ConstrainedBox(
          constraints: BoxConstraints.expand(height: size.height / 2.6, width: 70,),
          child: Transform.scale(
            scale: gift.id == 25 || gift.id == 28 ? 0.98: 0.85,
            child: CachedNetworkImage(
              imageUrl: gift.image,
              fit: BoxFit.scaleDown,
              height: 100,
              width: 100,
              placeholder: (context, url) => SizedBox(height: 25, width: 25, child: Center(child:CupertinoActivityIndicator())),
              errorWidget: (context, url, error) => Icon(Icons.image_outlined, color: Colors.teal, size: 60,),
            ),
          ),
        ),
      ),
    );
  }
}

class _LuckPath extends CustomClipper<Path> {
  final double angle;

  _LuckPath(this.angle);

  @override
  Path getClip(Size size) {
    Path _path = Path();
    Offset _center = size.center(Offset.zero);
    Rect _rect = Rect.fromCircle(center: _center, radius: size.width / 2);
    _path.moveTo(_center.dx, _center.dy);
    _path.arcTo(_rect, -pi / 2 - angle / 2, angle , false);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(_LuckPath oldClipper) {
    return angle != oldClipper.angle;
  }
}

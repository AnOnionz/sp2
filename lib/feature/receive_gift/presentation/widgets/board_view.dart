import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';

class BoardView extends StatefulWidget {
  final double angle;
  final double current;
  final Size size;
  final indexLucky;
  final List<GiftEntity> items;

  const BoardView(
      {Key key,
      this.angle,
      this.current,
      this.items,
      this.size,
      this.indexLucky})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BoardViewState();
  }
}

class _BoardViewState extends State<BoardView> {
  double _rotote(int index) => (index / widget.items.length) * 2 * pi;

  @override
  Widget build(BuildContext context) {
    var myAngle = widget.items.length == 6
        ? 2 * pi / widget.items.length
        : pi / widget.items.length;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //shadow
        Container(
          height: widget.size.height,
          width: widget.size.width,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)]),
        ),
        Transform.rotate(
          angle: -(widget.current + widget.angle) * 2 * pi +
              myAngle,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
//              Container(
//                height: widget.size.height *1.105,
//                width: widget.size.width *1.105,
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                    image: AssetImage("assets/images/board.png",)
//                  )
//                ),
//              ),
              for (var gift in widget.items) ...[_buildCard(gift)],
              for (var gift in widget.items) ...[_buildImage(gift)],
            ],
          ),
        ),
      ],
    );
  }

  _buildCard(GiftEntity gift) {
    var _rotate = _rotote(widget.items.indexOf(gift));
    var _angle = 2 * pi / widget.items.length - .009;
    int indexOf = widget.items.indexOf(gift);
    int _indexLucky = widget.indexLucky ?? 0;
    return Transform.rotate(
      angle: _rotate,
      child: Stack(
        children: [
          ClipPath(
            clipper: _LuckPath(_angle),
            child: Container(
              height: widget.size.height,
              width: widget.size.width,
              decoration: BoxDecoration(
                  color: indexOf % 2 == 0 ? Colors.red : Colors.white
//            image: DecorationImage(
//              alignment: Alignment.topCenter,
//              image: indexOf % 2 == 0 ? AssetImage("assets/images/vong22.png"): AssetImage("assets/images/vong11.png"),
//              scale: 2.479 //7.3//5.6
//            ),
                  ),
            ),
          ),
          CustomPaint(
              painter: BoxShadowPainter(_angle, indexOf),
              child: Container(
                height: widget.size.height,
                width: widget.size.width,
              )),
          CustomPaint(
              painter: _LuckyGiftBorder(
                  index: indexOf, indexLucky: _indexLucky, angle: _angle),
              child: Container(
                height: widget.size.height,
                width: widget.size.width,
              )),
        ],
      ),
    );
  }

  _buildImage(GiftEntity gift) {
    var _rotate = _rotote(widget.items.indexOf(gift));
    return Transform.rotate(
      angle: _rotate,
      child: Container(
        height: widget.size.height,
        width: widget.size.width,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: widget.size.height / 2.5,
            width: 70,
          ),
          child: Transform.scale(
            scale:
                gift.id == 1 || gift.id == 3 || gift.id == 7 || gift.id == 1001
                    ? 0.65
                    : 1.05,
            child: CachedNetworkImage(
              imageUrl: gift.image,
              fit: BoxFit.scaleDown,
              height: 100,
              width: 100,
              placeholder: (context, url) => SizedBox(
                  height: 25,
                  width: 25,
                  child: Center(child: CupertinoActivityIndicator())),
              errorWidget: (context, url, error) => Icon(Icons.image_outlined, color: Colors.white70, size: 60,),
            ),
          ),
        ),
      ),
    );
  }
}

class BoxShadowPainter extends CustomPainter {
  final double angle;
  final int index;

  BoxShadowPainter(this.angle, this.index);
  @override
  void paint(Canvas canvas, Size size) {
    Path _path = Path();
    Paint _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.teal;
    // here are my custom shapes
    Offset _center = size.center(Offset.zero);
    Rect _rect = Rect.fromCircle(center: _center, radius: size.width / 2);
    if (index % 2 != 0) {
      _path.moveTo(_center.dx, _center.dy);
      _path.arcTo(_rect, -pi / 2 - angle / 2, angle, false);
      _path.close();
      canvas.drawPath(_path, _paint);
    } else {
      _path.moveTo(_center.dx, _center.dy);
      _path.close();
      canvas.drawPath(_path, _paint);
    }
  }

  @override
  bool shouldRepaint(BoxShadowPainter oldDelegate) {
    return angle != oldDelegate.angle;
  }
}

class _LuckyGiftBorder extends CustomPainter {
  final double angle;
  final int index;
  final int indexLucky;

  _LuckyGiftBorder({this.index, this.angle, this.indexLucky});

  @override
  void paint(Canvas canvas, Size size) {
    Path _path = Path();
    Paint _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..color = Colors.yellow;
    // here are my custom shapes
    Offset _center = size.center(Offset(0, -4));
    Rect _rect = Rect.fromCircle(center: _center, radius: size.width / 2 - 4);
    if (index == indexLucky) {
      _path.moveTo(_center.dx, _center.dy);
      _path.arcTo(_rect, -pi / 2 - angle / 2, angle, false);
      _path.close();
      canvas.drawPath(_path, _paint);
    } else {
      _path.moveTo(_center.dx, _center.dy);
      _path.close();
      canvas.drawPath(_path, _paint);
    }
  }

  @override
  bool shouldRepaint(_LuckyGiftBorder oldDelegate) {
    return angle != oldDelegate.angle;
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
    _path.arcTo(_rect, -pi / 2 - angle / 2, angle, false);
    _path.close();

    return _path;
  }

  @override
  bool shouldReclip(_LuckPath oldClipper) {
    return angle != oldClipper.angle;
  }
}

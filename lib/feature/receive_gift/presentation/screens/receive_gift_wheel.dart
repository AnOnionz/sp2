import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/board_view.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/shadow.dart';

import '../../../../di.dart';

class ReceiveGiftWheelPage extends StatefulWidget {
  final FormEntity form;
  final List<GiftEntity> giftLucky; // gift se nhan trong vong quay
  final List<Gift> giftReceive; // gift se nhan toan bo activity
  final List<GiftEntity> giftReceived; // gift da nhan
  final List<GiftEntity> giftSBReceived;
  final int giftAt;

  const ReceiveGiftWheelPage({
    Key key,
    this.form,
    this.giftReceive,
    this.giftSBReceived,
    this.giftReceived,
    this.giftAt,
    this.giftLucky,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReceiveGiftWheelState();
}

class _ReceiveGiftWheelState extends State<ReceiveGiftWheelPage>
    with SingleTickerProviderStateMixin {
  Size get size => Size(MediaQuery.of(context).size.width * 0.68,
      MediaQuery.of(context).size.width * 0.68);
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  double _angle = 0;
  double _current = 0;
  AnimationController _ctrl;
  Animation _ani;
  List<int> _lucky;
  List<GiftEntity> _items;
  int _indexGift;
  bool doAnimation = true;

  @override
  void initState() {
    super.initState();
    _items =
        List.castFrom(local.fetchGift());
    if(_items.length == 5){
      final nen = _items.firstWhere((element) => element is Nen).clone();
      _items.insert(3, nen);
    }
    _lucky = widget.giftLucky.map<int>((e) {
      return _items.indexOf(_items.firstWhere((element) => element.giftId == e.giftId, orElse: ()=> null),);
    }).toList();
    var _duration = Duration(milliseconds: 2500);
    _ctrl = AnimationController(duration: _duration, vsync: this)
      ..addListener(() async {
        if (_ctrl.status == AnimationStatus.completed) {
          setState(() {
            doAnimation = false;
          });
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {
            _indexGift = _calIndex(_ani.value * _angle + _current);
            print('index at $_indexGift');
            BlocProvider.of<ReceiveGiftBloc>(context).add(ShowGiftWheel(
              gift: _items[_indexGift],
              giftAt: widget.giftAt,
              giftReceived: widget.giftReceived,
              giftReceive: widget.giftReceive,
              giftSBReceived: widget.giftSBReceived,
              form: widget.form,
            ));
          });
        }
      });
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.linearToEaseOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background-wheel.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height / 5),
                      child: Stack(
                        children: [
                          Container(
                            height: size.height * 1.14,
                            width: size.width * 1.14,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                              "assets/images/board.png",
                            ))),
                          ),
                          _items.length == 6 ? Positioned(
                              top: size.height * 0.265,
                              right: size.height * 0.095,
                              child: Container(
                                height:65,
                                width: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                  BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                                ],
                                ),
                              )):Positioned(
                              top: size.height * 0.17,
                              right: size.height * 0.17,
                              child: Container(
                                height:65,
                                width: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                              )),
                          Positioned(
                            top: size.height * 0.05,
                            right: size.height * 0.05,
                            bottom: size.height * 0.05,
                            left: size.height * 0.05,
                            child: GestureDetector(
                              onTap: doAnimation ? _animation :(){},
                              child: AnimatedBuilder(
                                  animation: _ani,
                                  builder: (context, child) {
                                    final _value = _ani.value;
                                    final _angle = _value * this._angle;
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        BoardView(
                                          items: _items,
                                          current: _current,
                                          angle: _angle,
                                          size: size,
                                          indexLucky:_calIndex(_ani.value * _angle + _current),
                                        ),
                                        _buildGo(),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          _items.length == 6 ? Positioned(
                              top: size.height * 0.275,
                              right: size.height * 0.1,
                              child: Image.asset(
                                "assets/images/arrow6.png",
                                height: 38,
                              )): Positioned(
                              top: size.height * 0.175,
                              right: size.height * 0.175,
                              child: Image.asset(
                                "assets/images/arrow4.png",
                                height: 38,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'BẠN CÒN LẠI ',
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 25)),
                              TextSpan(
                                  text:
                                      '${widget.giftReceive.length - widget.giftReceived.length}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                      fontSize: 26)),
                              TextSpan(
                                  text: ' LƯỢT QUAY',
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 25)),
                            ]),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  boxShadow: [
                                    CustomBoxShadow(
                                        color: Colors.white,
                                        offset: new Offset(0, 0),
                                        blurRadius: 12.0,
                                        blurStyle: BlurStyle.outer)
//
                                  ],
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0),
                                  child: Center(
                                    child: Text(
                                      widget.form.customer.name,
                                      style: MessageTitle1white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  boxShadow: [
                                    CustomBoxShadow(
                                        color: Colors.white,
                                        offset: new Offset(0, 0),
                                        blurRadius: 12.0,
                                        blurStyle: BlurStyle.outer)
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0),
                                  child: Center(
                                    child: Text(
                                      widget.form.customer.phoneNumber,
                                      style: MessageTitle1white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  child:
                  Text(MyPackageInfo.packageInfo.version)),
            ],
          ),
        ),
      ),
    );
  }

  _buildGo() {
    return Align(
        child: InkWell(
            onTap: doAnimation ? _animation :(){} ,
            child: Image.asset(
              "assets/images/hinhtron.png",
              height: 50,
            )));
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = _lucky[Random().nextInt(_lucky.length)] / _items.length;
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }
}

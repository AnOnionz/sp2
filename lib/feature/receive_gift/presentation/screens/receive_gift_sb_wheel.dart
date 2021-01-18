import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/sb_board_view.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/shadow.dart';

import '../../../../di.dart';

class ReceiveGiftSBWheelPage extends StatefulWidget {
  final FormEntity form;
  final List<GiftEntity> giftLucky; // gift se nhan trong vong quay
  final List<Gift> giftReceive; // gift se nhan toan bo activity
  final List<GiftEntity> giftReceived;// gift da nhan
  final List<GiftEntity> giftSBReceived;
  final int giftAt;

  const ReceiveGiftSBWheelPage({Key key, this.form, this.giftReceive, this.giftSBReceived, this.giftReceived, this.giftAt, this.giftLucky}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReceiveGiftSBWheelState();
}

class _ReceiveGiftSBWheelState extends State<ReceiveGiftSBWheelPage>
    with SingleTickerProviderStateMixin {
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  double _angle = 0;
  double _current = 0;
  AnimationController _ctrl;
  Animation _ani ;
  List<int> _lucky ;
  List<GiftEntity> _items;
  int _indexGift;
  bool doAnimation = true;

  @override
  void initState() {
    super.initState();
    List<GiftEntity> gifts = local.fetchGiftStrongbow().toList();
    _items = [...gifts, ...gifts.map((e) => e.clone()).toList()];
    _lucky = widget.giftLucky.map<int>((e) => e.id - 23).toList();
    var _duration = Duration(milliseconds: 2500);
    _ctrl = AnimationController(duration: _duration, vsync: this)
      ..addListener(() async{
        if (_ctrl.status == AnimationStatus.completed) {
          setState(() {
            doAnimation = false;
          });
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _indexGift = _calIndex(_ani.value * _angle + _current);
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
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
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
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 11),
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
                                  SBBoardView(
                                      items: _items, current: _current, angle: _angle),
                                  _buildGo(),
                                ],
                              );
                            }),
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
                                  '${widget.giftReceive.length - widget.giftReceived.length - widget.giftSBReceived.length}',
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
        alignment: Alignment.center,
        child: InkWell(
            onTap: doAnimation ? _animation : (){},
            child: Image.asset(
              "assets/images/nutsb.png",
              height: 140,
            )));
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = _lucky[Random().nextInt(_lucky.length)] / _items.length;
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        setState(() {
          _current = 0;
        });
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }
}

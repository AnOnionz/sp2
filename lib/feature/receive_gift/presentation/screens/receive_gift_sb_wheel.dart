import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/board_view.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/sb_board_view.dart';

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

  @override
  void initState() {
    super.initState();
//    final gifts = local.fetchGift().sublist(8);
//    _items = [gifts].expand((element) =>[element, element]).toList().expand((element) => element).toList();
//    _lucky = widget.giftLucky.map<int>((e) => e.id + 3).toList();
    _items = [StrongBowGift(), Nen(), Voucher(),Pack4(),Pack6(),Alu()];
    _lucky = [1,2,3];
    var _duration = Duration(milliseconds: 1000);
    _ctrl = AnimationController(duration: _duration, vsync: this)
      ..addListener(() async{
        if (_ctrl.status == AnimationStatus.completed) {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _indexGift = _calIndex(_ani.value * _angle + _current);
            print('index $_indexGift');
            print("items: $_items");
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
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "CHÚC MỪNG BẠN ĐÃ NHẬN ĐUỢC 1 VÒNG QUAY ",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
                AnimatedBuilder(
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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Center(
                                child: Text(
                                  widget.form.customer.name,
                                  style: Subtitle1white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Center(
                                child: Text(
                                  widget.form.customer.phoneNumber,
                                  style: Subtitle1white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 15),
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Color(0XFFFF0000),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Center(
                            child: Text(
                              "Tiếp tục",
                              style: Subtitle1white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildGo() {
    return Align(
        alignment: Alignment.center,
        child: InkWell(
            onTap: _animation,
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
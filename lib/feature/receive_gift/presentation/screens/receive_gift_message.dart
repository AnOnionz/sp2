import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/platform/package_info.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/next_button.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/shadow.dart';

class ReceiveGiftMessagePage extends StatefulWidget {
  final FormEntity form;
  final List<Gift> giftReceive;
  final List<GiftEntity> giftReceived;
  final List<GiftEntity> giftSBReceived;
  final int giftAt;
  final int gifSBtAt;

  const ReceiveGiftMessagePage(
      {Key key,
      this.form,
      this.giftReceive,
      this.giftSBReceived,
      this.giftReceived,
      this.giftAt,
      this.gifSBtAt})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReceiveGiftMessageState();
}

class _ReceiveGiftMessageState extends State<ReceiveGiftMessagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gift =
        [...widget.giftReceived, ...widget.giftSBReceived][widget.giftAt];
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(gift.asset),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: NextButton(onPress: () {
                        BlocProvider.of<ReceiveGiftBloc>(context).add(GiftNext(
                          form: widget.form,
                          giftReceived: widget.giftReceived,
                          giftSBReceived: widget.giftSBReceived,
                          giftReceive: widget.giftReceive,
                          giftAt: widget.giftAt + 1,
                        ));
                      },),
                    ),
//                    InkWell(
//                      onTap: () {
//                        BlocProvider.of<ReceiveGiftBloc>(context).add(GiftNext(
//                          form: widget.form,
//                          giftReceived: widget.giftReceived,
//                          giftSBReceived: widget.giftSBReceived,
//                          giftReceive: widget.giftReceive,
//                          giftAt: widget.giftAt + 1,
//                        ));
//                      },
//                      child: Padding(
//                        padding: const EdgeInsets.only(bottom: 15, top: 15),
//                        child: Container(
//                          width: double.infinity,
//                          height: 45,
//                          padding: const EdgeInsets.all(12.0),
//                          decoration: BoxDecoration(
//                            color: Color(0XFFFF0000),
//                            borderRadius: BorderRadius.circular(3.0),
//                          ),
//                          child: Center(
//                            child: Text(
//                              "Tiếp tục",
//                              style: Subtitle1white,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
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
}

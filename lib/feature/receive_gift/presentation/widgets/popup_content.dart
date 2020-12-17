import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';


class PopupContent extends StatefulWidget {
  final ReceiveGiftBloc bloc;

  const PopupContent({Key key, this.bloc}) : super(key: key);

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiveGiftBloc, ReceiveGiftState>(
      cubit: widget.bloc,
      builder: (context, state) {
        if (state is ReceiveGiftHandling) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ReceiveGiftPopup) {
          return IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 15, bottom: 15),
              child: Column(
                children: [
                  ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Danh sách sản phẩm đổi quà",
                        style: Headline6black,
                      ),
                    ),
                  ],
                  ...state.form.products
                      .where(
                          (element) => element.controller.text.isNotEmpty)
                      .map((product) => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.productName,
                                  style: Subtitle1black,
                                ),
                                Text(
                                  product.controller.text,
                                  style: Subtitle1black,
                                )
                              ],
                            ),
                          ))
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Divider(
                      height: 1,
                      color: silverColor,
                    ),
                  ),
                  state.form.voucher != null
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Giảm giá", style: Discount),
                                Text(
                                  '${state.form.numberOfVoucher} voucher - ${state.form.numberOfVoucher * 2}0.000 VNĐ',
                                  style: Discount,
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 15),
                              child: Text(
                                "Nhập mã giảm giá thành công",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                "Hủy",
                                style: Headline6white,
                              )),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () async {
                              widget.bloc.add(ReceiveGiftConfirm(form: state.form));
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                'Xác nhận',
                                style: Headline6white,
                              )),
                              decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ReceiveGifShowTurn) {
          return IntrinsicWidth(
            child: Column(
              children: [
                Text(state.message),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Future.delayed(Duration(milliseconds: 500));
                    widget.bloc.add(GiftNext(customer: state.customer, products: state.products, takeProductImg: state.takeProductImg, giftAt: 0, giftReceive: state.gifts, giftReceived: []));
                    },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Ok"),
                  ),
                )
              ],
            ),
          );
        }
        return ZoomOut(child: Container(color: Colors.white.withOpacity(0),));
      },
    );
  }
}

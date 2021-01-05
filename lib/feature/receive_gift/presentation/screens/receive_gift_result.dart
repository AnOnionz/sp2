import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';

class ReceiveGiftResultPage extends StatefulWidget {
  final ReceiveGiftEntity entity;

  const ReceiveGiftResultPage({
    Key key,
    this.entity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReceiveGiftResultState();
}

class _ReceiveGiftResultState extends State<ReceiveGiftResultPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  List<File> takeGiftImg = [];
  List<File> approveImg = [];

  Future getTakeGiftImage() async {
    if (takeGiftImg.length < 5) {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: 480, maxHeight: 640);
      if (pickedFile != null) {
        setState(() {
          takeGiftImg.add(File(pickedFile.path));
        });
      }
    }
  }

  Future getApproveImage() async {
    if (approveImg.length < 5) {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: 480, maxHeight: 640);
      if (pickedFile != null) {
        setState(() {
          approveImg.add(File(pickedFile.path));
        });
      }
    }
  }

  void previewTakeGiftImage(File image, int index) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PreviewImageDialog(
          textButton: 'Xóa',
          image: image,
          onTap: () {
            setState(() {
              takeGiftImg.removeAt(index);
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void previewApproveImage(File image, int index) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PreviewImageDialog(
          textButton: 'Xóa',
          image: image,
          onTap: () {
            setState(() {
              approveImg.removeAt(index);
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "CHÚC MỪNG BẠN ĐÃ GIẢI THƯỞNG",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )),
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Hình ảnh",
                                      style: Subtitle1white,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Phần quà",
                                      style: Subtitle1white,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Số lượng",
                                      style: Subtitle1white,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                itemCount: widget.entity.gifts.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.entity.gifts[index].image,
                                          height: 100,
                                          width: 100,
                                          placeholder: (context, url) => SizedBox(height: 20, width: 20, child: Center(child:CupertinoActivityIndicator())),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          widget.entity.gifts[index].name,
                                          style: Subtitle1white,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${widget.entity.gifts[index].amountReceive} phần',
                                          style: Subtitle1white,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: const Text('Khách nhận quà:',
                                            style: formText)),
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Material(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: InkWell(
                                                onTap: () {
                                                  getTakeGiftImage();
                                                },
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Image.asset(
                                                      'assets/images/camera.png'),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Container(
                                                height: 60,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  children: takeGiftImg.map((e) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        previewTakeGiftImage(
                                                            e,
                                                            takeGiftImg
                                                                .indexOf(e));
                                                      },
                                                      child: Container(
                                                        height: 60,
                                                        width: 60,
                                                        margin: takeGiftImg
                                                                    .indexOf(e) ==
                                                                takeGiftImg
                                                                        .length -
                                                                    1
                                                            ? const EdgeInsets
                                                                .only(right: 0)
                                                            : const EdgeInsets
                                                                .only(right: 10),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5)),
                                                          child: Image.file(e,
                                                              fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: const Text('Biên bản xác nhận:',
                                            style: formText)),
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Material(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: InkWell(
                                                onTap: () {
                                                  getApproveImage();
                                                },
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Image.asset(
                                                      'assets/images/camera.png'),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Container(
                                                height: 60,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  children: approveImg.map((e) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        previewApproveImage(
                                                            e,
                                                            approveImg
                                                                .indexOf(e));
                                                      },
                                                      child: Container(
                                                        height: 60,
                                                        width: 60,
                                                        margin: approveImg
                                                                    .indexOf(e) ==
                                                                approveImg
                                                                        .length -
                                                                    1
                                                            ? const EdgeInsets
                                                                .only(right: 0)
                                                            : const EdgeInsets
                                                                .only(right: 10),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5)),
                                                          child: Image.file(e,
                                                              fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
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
                                  widget.entity.customer.name,
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
                                  widget.entity.customer.phoneNumber,
                                  style: Subtitle1white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if(takeGiftImg.length == 0 || approveImg.length == 0){
                          _scaffoldKey.currentState
                              .removeCurrentSnackBar();
                          _scaffoldKey.currentState
                              .showSnackBar(
                            SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                    "Yêu cầu chụp ảnh trước khi trao quà "),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        return;
                        }
                        final a = ReceiveGiftSubmit(receiveGiftEntity: ReceiveGiftEntity(customer: widget.entity.customer, products: widget.entity.products, gifts: widget.entity.gifts, productImage: widget.entity.productImage, receiptImage: approveImg, customerImage: takeGiftImg, voucher: widget.entity.voucher, outletCode: widget.entity.outletCode, voucherReceived: widget.entity.voucherReceived));
                        BlocProvider.of<ReceiveGiftBloc>(context).add(a);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
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
                              "Hoàn thành trao quà",
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
}

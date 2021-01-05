import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/usecases/handle_receive_gift_usecase.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/build_list_product.dart';

import '../../../../di.dart';

class ReceiveGiftFormPage extends StatefulWidget {
  const ReceiveGiftFormPage({
    Key key,
  }) : super(key: key);

  @override
  _ReceiveGiftFormPageState createState() => _ReceiveGiftFormPageState();
}

enum i18 { yes, no }

class _ReceiveGiftFormPageState extends State<ReceiveGiftFormPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  final picker = ImagePicker();
  TextEditingController ctrlPhoneNumber;
  TextEditingController ctrlCustomerName;
  TextEditingController ctrlVoucher;
  FocusNode customerFocus;
  FocusNode phoneNumberFocus;
  FocusNode voucherFocus;
  i18 is18 = i18.yes;
  FormEntity _form;

  Future getImage() async {
    if (_form.images.length < 5) {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: 480, maxHeight: 640);
      if (pickedFile != null) {
        setState(() {
          _form.images.add(File(pickedFile.path));
        });
      }
    }
  }

  void previewImage(File image, int index) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PreviewImageDialog(
          textButton: 'Xóa',
          image: image,
          onTap: () {
            _form.images.removeAt(index);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final List<ProductEntity> products = List.castFrom(local.fetchProduct());
    _form = FormEntity(
      customer: CustomerEntity(name: "abs", phoneNumber: "0908783465"),
      products: products,
      images: [],
      voucher: null,
      isCheckedVoucher: false,
    );
    ctrlPhoneNumber = TextEditingController(text: _form.customer.phoneNumber);
    ctrlCustomerName = TextEditingController(text: _form.customer.name);
    ctrlVoucher = TextEditingController();

    phoneNumberFocus = FocusNode();
    customerFocus = FocusNode();
    voucherFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: _form.products.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                          child: const Text(
                            'ĐỔI QUÀ',
                            style: header,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: const Text('Tên khách hàng',
                                        style: formText)),
                                Expanded(
                                  child: Container(
                                    height: 43,
                                    child: InputField(
                                      enable: is18 == i18.yes ? true : false,
                                      thisFocus: customerFocus,
                                      nextFocus: phoneNumberFocus,
                                      controller: ctrlCustomerName
                                        ..addListener(() {
                                          _form.customer.name =
                                              ctrlCustomerName.text;
                                        }),
                                      textAlign: TextAlign.left,
                                      hint: '',
                                      textCapitalization:
                                          TextCapitalization.words,
                                      inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]+$'))],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: const Text(
                                        'Khách hàng đủ 18 tuổi chưa ?',
                                        style: formText)),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Radio(
                                          value: i18.yes,
                                          groupValue: is18,
                                          activeColor: Colors.deepOrange,
                                          onChanged: (i18 value) {
                                            setState(() {
                                              is18 = value;
                                              _scaffoldKey.currentState
                                                  .removeCurrentSnackBar();
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: const Text("Yes",
                                              style: formText),
                                        ),
                                      ],
                                    )),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Radio(
                                          value: i18.no,
                                          groupValue: is18,
                                          activeColor: Colors.deepOrange,
                                          onChanged: (i18 value) {
                                            setState(() {
                                              is18 = value;
                                              _scaffoldKey.currentState
                                                  .removeCurrentSnackBar();
                                              _scaffoldKey.currentState
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Khách hàng chưa đủ 18 tuổi'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child:
                                              const Text("No", style: formText),
                                        ),
                                      ],
                                    )),
                                  ],
                                )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: const Text('Số điện thoại',
                                        style: formText),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 43,
                                      child: InputField(
                                        enable: is18 == i18.yes ? true : false,
                                        thisFocus: phoneNumberFocus,
                                        nextFocus: _form.products.first.focus,
                                        controller: ctrlPhoneNumber
                                          ..addListener(() {
                                            _form.customer.phoneNumber =
                                                ctrlPhoneNumber.text;
                                          }),
                                        textAlign: TextAlign.left,
                                        hint: '',
                                        textCapitalization:
                                            TextCapitalization.words,
                                        inputType: TextInputType.number,
                                        inputFormatter: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BuildListProduct(
                              is18: is18 == i18.yes,
                              products: _form.products,
                              nextFocus: voucherFocus,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: const Text('Mã giảm giá',
                                        style: formText),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 43,
                                            child: InputField(
                                              enable: is18 == i18.yes
                                                  ? true
                                                  : false,
                                              thisFocus: voucherFocus,
                                              nextFocus: null,
                                              controller: ctrlVoucher,
                                              textAlign: TextAlign.left,
                                              onSubmit: (_) {
                                                BlocProvider.of<
                                                            ReceiveGiftBloc>(
                                                        context)
                                                    .add(UseVoucher(
                                                        phone: ctrlVoucher.text
                                                            .trim()));
                                              },
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              inputType: TextInputType.number,
                                              inputFormatter: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]'))
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        BlocConsumer<ReceiveGiftBloc,
                                                ReceiveGiftState>(
                                            listener: (context, state) {
                                          if (state is UseVoucherSuccess) {
                                            _form.isCheckedVoucher = true;
                                            _form.voucher = state.voucher;
                                            _scaffoldKey.currentState
                                                .removeCurrentSnackBar();
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Text(
                                                      "Số điện thoại này có ${state.voucher.qty} mã giảm giá"),
                                                ),
                                                backgroundColor: greenColor,
                                              ),
                                            );
                                          }
                                          if (state is UseVoucherFailure) {
                                            _form.isCheckedVoucher = false;
                                            _form.voucher = null;
                                            _scaffoldKey.currentState
                                                .removeCurrentSnackBar();
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Text(
                                                      "Số điện thoại này không có mã giảm giá"),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }, builder: (context, state) {
                                          if (state is UseVoucherLoading) {
                                            return Container(
                                              height: 43,
                                              width: 43,
                                              decoration: BoxDecoration(
                                                color: greenCentColor,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child:
                                                        CupertinoActivityIndicator()),
                                              ),
                                            );
                                          }
                                          return InkWell(
                                            onTap: is18 == i18.yes
                                                ? () {
                                                    if (ctrlVoucher
                                                            .text.length ==
                                                        0) {
                                                      _scaffoldKey.currentState
                                                          .removeCurrentSnackBar();
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: Text(
                                                                "Vui vòng nhập mã giảm giá"),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      return;
                                                    }
//                                                    if(ctrlVoucher.text.length != 10 || !RegExp(r'^0[^01]([0-9]+)').hasMatch(ctrlVoucher.text)){
//
//                                                    }
                                                    BlocProvider.of<
                                                                ReceiveGiftBloc>(
                                                            context)
                                                        .add(UseVoucher(
                                                            phone: ctrlVoucher
                                                                .text
                                                                .trim()));
                                                  }
                                                : () {},
                                            child: Container(
                                              height: 43,
                                              width: 43,
                                              decoration: BoxDecoration(
                                                color: greenCentColor,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "assets/images/check_voucher.png",
                                                  width: 30,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: const Text(
                                          'khách hàng và sản phẩm',
                                          style: formText)),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Material(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: InkWell(
                                              onTap: is18 == i18.yes
                                                  ? () {
                                                      getImage();
                                                    }
                                                  : () {},
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
                                                children: _form.images.map((e) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      previewImage(
                                                          e,
                                                          _form.images
                                                              .indexOf(e));
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      margin: _form.images
                                                                  .indexOf(e) ==
                                                              _form.images
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
                            Container(
                              height: 1,
                              color: Colors.white,
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              margin: EdgeInsets.only(
                                bottom: 20,
                                top: 20,
                              ),
                              child: Builder(
                                builder: (context) => BlocListener<
                                    ReceiveGiftBloc, ReceiveGiftState>(
                                  listener: (context, state) {
                                    if (state is FormError) {
                                      _scaffoldKey.currentState
                                          .removeCurrentSnackBar();
                                      _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(state.message),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    if (state is NoImage) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ZoomIn(
                                              delay:
                                                  Duration(milliseconds: 100),
                                              child: CupertinoAlertDialog(
                                                title: Text("Thông báo"),
                                                content: Text(
                                                  "Bạn phải chụp ảnh để tiếp tục đổi quà",
                                                  style: Subtitle1black,
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      textStyle: TextStyle(
                                                          color: Colors.red),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Hủy")),
                                                  CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        getImage();
                                                      },
                                                      child: Text(
                                                        "Chụp hình",
                                                      )),
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                    if (state is ReceiveGiftHandling) {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) {
                                            return ZoomIn(
                                              delay:
                                                  Duration(milliseconds: 300),
                                              child: SimpleDialog(
                                                children: [
                                                  Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      radius: 16,
                                                    ),
                                                  )
                                                ],
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                    if (state is ReceiveGiftPopup) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) {
                                            return ZoomIn(
                                              delay:
                                                  Duration(milliseconds: 300),
                                              child: SimpleDialog(
                                                children: [
                                                  IntrinsicWidth(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 25,
                                                              right: 25,
                                                              top: 15,
                                                              bottom: 15),
                                                      child: Column(
                                                        children: [
                                                          ...[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15),
                                                              child: Text(
                                                                "Danh sách sản phẩm đổi quà",
                                                                style:
                                                                    Headline6black,
                                                              ),
                                                            ),
                                                          ],
                                                          ...state.form.products
                                                              .map(
                                                                  (product) =>
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 15.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              product.productName,
                                                                              style: Subtitle1black,
                                                                            ),
                                                                            Text(
                                                                              product.buyQty.toString(),
                                                                              style: Subtitle1black,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ))
                                                              .toList(),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    bottom:
                                                                        15.0),
                                                            child: Divider(
                                                              height: 1,
                                                              color:
                                                                  silverColor,
                                                            ),
                                                          ),
                                                          state.form.voucher !=
                                                                  null
                                                              ? Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            "Giảm giá",
                                                                            style:
                                                                                Discount),
                                                                        Text(
                                                                          '${state.form.voucher.qty} voucher - ${state.form.voucher.qty * 2}0.000 VNĐ',
                                                                          style:
                                                                              Discount,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              30,
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          Text(
                                                                        "Nhập mã giảm giá thành công",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .blue,
                                                                            fontSize:
                                                                                17,
                                                                            fontStyle:
                                                                                FontStyle.italic),
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
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      width: double
                                                                          .infinity,
                                                                      child: Center(
                                                                          child: Text(
                                                                        "Hủy",
                                                                        style:
                                                                            Headline6white,
                                                                      )),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .red,
                                                                        borderRadius:
                                                                            BorderRadius.circular(3.0),
                                                                      ),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      BlocProvider.of<ReceiveGiftBloc>(
                                                                              context)
                                                                          .add(ReceiveGiftConfirm(
                                                                              form: state.form));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      width: double
                                                                          .infinity,
                                                                      child: Center(
                                                                          child: Text(
                                                                        'Xác nhận',
                                                                        style:
                                                                            Headline6white,
                                                                      )),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            greenColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(3.0),
                                                                      ),
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                    if (state is ReceiveGifShowTurn) {
                                      Navigator.pop(context);
                                      switch (state.type) {
                                        case 1:
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) {
                                                return ZoomIn(
                                                  delay: Duration(
                                                      milliseconds: 300),
                                                  child: SimpleDialog(
                                                    children: [
                                                      IntrinsicWidth(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/open-box.png",
                                                              height: 70,
                                                              width: 70,
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            const Text(
                                                              "CẢM ƠN BẠN ĐÃ MUA HÀNG",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color:
                                                                      greenColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              state.message,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                await Future.delayed(
                                                                    Duration(
                                                                        milliseconds:
                                                                            500));
                                                                BlocProvider.of<
                                                                            ReceiveGiftBloc>(
                                                                        context)
                                                                    .add(
                                                                        GiftNext(
                                                                  form: state.form,
                                                                  setCurrent: state.setCurrent,
                                                                  giftAt: 0,
                                                                  giftReceive:
                                                                      state
                                                                          .gifts,
                                                                  giftReceived: [],
                                                                  giftSBReceived: [],
                                                                ));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15),
                                                                child:
                                                                    Container(
                                                                  width: 250,
                                                                  height: 35,
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        greenColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            3.0),
                                                                  ),
                                                                  child: Text(
                                                                    "OK",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                    elevation: 5,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                );
                                              });
                                          break;
                                        case 2:
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) {
                                                return ZoomIn(
                                                  delay: Duration(
                                                      milliseconds: 300),
                                                  child: SimpleDialog(
                                                    children: [
                                                      IntrinsicWidth(
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/package.png",
                                                              height: 70,
                                                              width: 70,
                                                            ),
                                                            Text(
                                                              "CẢM ƠN BẠN ĐÃ MUA HÀNG",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .deepOrange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              state.message,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                            InkWell(
                                                                onTap:
                                                                    () async {
                                                                  BlocProvider.of<ReceiveGiftBloc>(context).add(ReceiveGiftOnlyBuyProducts(form: state.form));
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15),
                                                                  child:
                                                                      Container(
                                                                    width: 250,
                                                                    height: 35,
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .deepOrange,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              3.0),
                                                                    ),
                                                                    child: Text(
                                                                      "Ok",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                    elevation: 5,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                );
                                              });
                                          break;
                                      }
                                    }
                                    if (state is ReceiveGiftNotCondition) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      onTap: is18 == i18.yes
                                          ? () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              BlocProvider.of<ReceiveGiftBloc>(context)
                                                  .add(ReceiveGiftSubmitForm(
                                                      form: FormEntity(
                                                          products: _form.products.where((element) => element.buyQty > 0).toList(),
                                                          voucher:
                                                              _form.voucher,
                                                          customer:
                                                              _form.customer,
                                                          isCheckedVoucher: _form
                                                              .isCheckedVoucher,
                                                          images:
                                                              _form.images)));
                                            }
                                          : () {
                                              _scaffoldKey.currentState
                                                  .removeCurrentSnackBar();
                                              _scaffoldKey.currentState
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Khách hàng chưa đủ 18 tuổi'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                      child: const Center(
                                        child: Text(
                                          'LƯU',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff205527),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

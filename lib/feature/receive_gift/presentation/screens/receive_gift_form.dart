import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_2021/core/common/colors.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/core/common/textfield.dart';
import 'package:sp_2021/feature/attendance/presentation/widgets/preview_image_dialog.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';
import 'package:sp_2021/feature/receive_gift/presentation/blocs/receive_gift_bloc.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/build_list_product.dart';
import 'package:sp_2021/feature/receive_gift/presentation/widgets/popup_content.dart';

import '../../../../di.dart';

class ReceiveGiftFormPage extends StatefulWidget {

  const ReceiveGiftFormPage({Key key,}) : super(key: key);

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
          source: ImageSource.camera, maxWidth: 500, maxHeight: 600);
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

  _showListProductDialog({ReceiveGiftBloc bloc}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ZoomIn(
            delay: Duration(milliseconds: 300),
            child: SimpleDialog(
              children: [
                PopupContent(
                  bloc: bloc,
                ),
              ],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    final products = local.fetchProduct();
    _form = FormEntity(products: products, name: "abc", images: [], voucher: "123", numberOfVoucher: 1,isCheckedVoucher: false, phoneNumber: "0953302233" );
    ctrlPhoneNumber = TextEditingController(text: _form.phoneNumber);
    ctrlCustomerName = TextEditingController(text: _form.name);
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
                                      thisFocus: customerFocus,
                                      nextFocus: phoneNumberFocus,
                                      controller: ctrlCustomerName,
                                      textAlign: TextAlign.left,
                                      hint: '',
                                      textCapitalization:
                                          TextCapitalization.words,
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
                                        thisFocus: phoneNumberFocus,
                                        nextFocus:
                                        _form.products.first.focus,
                                        controller: ctrlPhoneNumber,
                                        textAlign: TextAlign.left,
                                        hint: '',
                                        textCapitalization:
                                            TextCapitalization.words,
                                        inputType: TextInputType.number,
                                        inputFormatter: <TextInputFormatter>[
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
                           BuildListProduct(products: _form.products, nextFocus: voucherFocus,),
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
                                              thisFocus: voucherFocus,
                                              nextFocus: null,
                                              controller: ctrlVoucher,
                                              textAlign: TextAlign.left,
                                              hint: '',
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              inputType: TextInputType.number,
                                              inputFormatter: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]'))
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                          },
                                          child: Container(
                                            height: 43,
                                            width: 43,
                                            decoration: BoxDecoration(
                                              color: greenCentColor,
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                      "assets/images/check_voucher.png", width: 30,),
                                              ),
                                          ),
                                        ),
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
                                              onTap: () {
                                                getImage();
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
                                                children:
                                                _form.images.map((e) {
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
                                    if (state is ReceiveGiftPopup) {
                                      _showListProductDialog(
                                          bloc:
                                              BlocProvider.of<ReceiveGiftBloc>(
                                                  context));
                                    }
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      onTap: () async {
                                        _scaffoldKey.currentState
                                            .removeCurrentSnackBar();
                                        if (ctrlPhoneNumber.text.length != 10 ||
                                            !RegExp(r'^0[^01]([0-9]+)')
                                                .hasMatch(
                                                    ctrlPhoneNumber.text)) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Số điện thoại không chính xác.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        if (ctrlCustomerName.text.length == 0) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập tên khách hàng.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        if (_form.images.length == 0) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Yêu cầu chụp hình hóa đơn.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        print("form:" + _form.toString());
                                        BlocProvider.of<ReceiveGiftBloc>(
                                                context)
                                            .add(ReceiveGiftSubmitForm(
                                                form: _form));
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

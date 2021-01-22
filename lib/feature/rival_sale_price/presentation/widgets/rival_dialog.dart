import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sp_2021/core/common/text_styles.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:sp_2021/feature/rival_sale_price/presentation/widgets/rival_product_ui.dart';

import '../../../../di.dart';

class RivalDialog extends StatefulWidget {
  final Function addRival;
  final Function close;

  const RivalDialog({Key key, this.addRival, this.close}) : super(key: key);
  @override
  _RivalDialogState createState() => _RivalDialogState();
}

class _RivalDialogState extends State<RivalDialog> {
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();
  List<RivalProductEntity> rivalsOther;
  List<RivalProductEntity> rivalsFound;
  TextEditingController _controller = TextEditingController();
  Fuzzy fuzzy;
  bool rivalNotFound;

  @override
  void initState() {
    super.initState();
    rivalNotFound = rivalNotFound ?? false;
    rivalsOther = _initData();
    rivalsFound = [];
    fuzzy = Fuzzy(
      rivalsOther.map((e) => e.name).toList(),
      options: FuzzyOptions(tokenize: true, threshold: 0.01, verbose: true,location: 0),
    );
  }

  List<RivalProductEntity> _initData() {
    return local
        .fetchRivalProduct()
        .where((element) => element.imgUrl == "https://sptt21.imark.vn/")
        .toList()
          ..sort((a, b) {
            return a.isAvailable.toString().length.compareTo(b.isAvailable.toString().length);
          });
  }

//  void _search() {
//    if (_controller.text.isNotEmpty) {
//      final result = fuzzy.search(_controller.text);
//      print(result.map((e) => e.item).toList());
//      List<RivalProductEntity> resultList = [];
//      setState(() {
//        final list = local
//            .fetchRivalProduct()
//            .where((element) => element.imgUrl == "https://sptt21.imark.vn/")
//            .toList();
//        for (final r in result) {
//          resultList.add(list.firstWhere((element) => element.name == r.item));
//        }
//        rivalsOther = resultList;
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print("a");
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Dialog(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            height: size.height * 0.7,
            width: size.height * 0.45,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Thêm bia đối thủ",
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.5,
                            child: Stack(
                              alignment: const Alignment(1.0, 1.0),
                              children: [
                                Container(
                                  height: 42,
                                  child: TextFormField(
                                    controller: _controller
                                      ..addListener(() {
                                        setState(() {
                                          if (_controller.text.isEmpty) {
                                            setState(() {
                                              rivalNotFound = false;
                                              rivalsOther = _initData();
                                              rivalsFound = [];
                                            });
                                          }
                                        });
                                      }),
                                    onChanged: (value) {
                                      if (_controller.text.isNotEmpty) {
                                        final result = fuzzy.search(value);
                                        setState(() {
                                          rivalsFound = local
                                              .fetchRivalProduct()
                                              .where((element) =>
                                                  element.imgUrl ==
                                                  "https://sptt21.imark.vn/")
                                              .toList()
                                              .where((element) => result
                                                  .map((e) => e.item)
                                                  .toList()
                                                  .contains(element.name))
                                              .toList();
                                          setState(() {
                                            rivalNotFound = rivalsFound.isEmpty;
                                          });
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Tìm kiếm bia đối thủ ...",
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(21)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(21)),
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(21)),
                                        borderSide: BorderSide(
                                            color: Color(0xffeaeaea)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(21)),
                                        gapPadding: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: _controller.text.isNotEmpty ? () {
                                        setState(() {
                                          _controller.clear();
                                        });
                                      } : (){},
                                      child: Container(
                                        height: 42,
                                        width: 42,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        ),
                                        child: _controller.text.isNotEmpty ? Icon(Icons.clear, color: Colors.white,
                                          size: 25,) : Icon(
                                          Icons.search_rounded,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: !rivalNotFound ? RivalProductUi(
                    rivals: rivalsFound.isEmpty ? rivalsOther : rivalsFound,
                    addRival: (String name, bool add) {
                      final temp = _initData();
                      setState(() {
                        rivalsOther = temp
                            .where((element) =>
                                rivalsOther
                                    .firstWhere((e) => e.id == element.id)
                                    .id ==
                                element.id)
                            .toList();
                      });
                      widget.addRival(name,add);
                    },
                  ): Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: FlareActor("assets/images/no_available.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: "Untitled"),
                      ),
                      Text(
                        "Không tìm thấy đối thủ nào",
                        style: TextStyle(color: Colors.grey
                            , fontSize: 17),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    widget.close();
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Center(
                          child: Text(
                        "Đóng",
                        style: Subtitle1black,
                      ))),
                )
              ],
            ),
          )),
    );
  }
}
//rivalsOther.length > 0
//? [
//...rivalsOther
//    .map((rival) => Padding(
//padding: const EdgeInsets.only(left: 25, right: 25, bottom: 2, top: 2),
//child: CheckboxListTile(
//secondary:  rival.isAvailable ? const Icon(Icons.remove) : const Icon(Icons.add),
//title: Text(rival.name.toUpperCase()),
//controlAffinity: ListTileControlAffinity.leading,
//activeColor: Colors.teal,
//value: rival.isAvailable,
//onChanged: (bool value) {
//setState(() {
//rival.isAvailable = value;
//rival.save();
//rivalsOther = local
//    .fetchRivalProduct()
//    .where((element) => element.imgUrl == "https://sptt21.imark.vn/")
//    .toList()..sort((a,b){
//return a.name.compareTo(b.name);
//});
//});
//widget.onPressed();
//},
//),
//))
//.toList(),
//...[
//FlatButton(
//onPressed: () {
//Navigator.pop(context);
//},
//child: Container(
//padding: const EdgeInsets.only(top: 5, bottom:5),
//width: 100,
//decoration: BoxDecoration(
//color: Colors.teal,
//borderRadius: BorderRadius.circular(12.0)
//),
//child: Center(
//child: Text(
//"Đóng",
//style: Subtitle1black,
//))),
//)
//]
//]
//: [
//Padding(
//padding: const EdgeInsets.all(12.0),
//child: Center(
//child: Column(
//children: [
//Container(
//height: 100,
//width: 100,
//child: FlareActor("assets/images/no_available.flr",
//alignment: Alignment.center,
//fit: BoxFit.contain,
//animation: "Untitled"),
//),
//Text(
//"Danh sách trống",
//style: TextStyle(color: Colors.grey
//, fontSize: 17),
//),
//],
//)),
//),
//FlatButton(
//onPressed: () {
//Navigator.pop(context);
//},
//child: Container(
//padding: const EdgeInsets.only(top: 5, bottom:5),
//width: 100,
//decoration: BoxDecoration(
//color: Colors.teal,
//borderRadius: BorderRadius.circular(12.0)
//),
//child: Center(
//child: Text(
//"Đóng",
//style: Subtitle1black,
//))),
//)

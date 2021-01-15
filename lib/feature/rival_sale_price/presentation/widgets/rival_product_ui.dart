import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';

import '../../../../di.dart';

class RivalProductUi extends StatefulWidget {
  final List<RivalProductEntity> rivals;
  final Function addRival;


  const RivalProductUi({Key key, this.rivals, this.addRival}) : super(key: key);

  @override
  _RivalProductUiState createState() => _RivalProductUiState();
}

class _RivalProductUiState extends State<RivalProductUi> {
  DashBoardLocalDataSource local = sl<DashBoardLocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return widget.rivals.length > 0 ? ListView.builder(
        shrinkWrap: true,
        itemCount: widget.rivals.length,
        physics: BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) => CheckboxListTile(
          secondary:  widget.rivals[index].isAvailable ? const Icon(Icons.remove) : const Icon(Icons.add),
          title: Text( widget.rivals[index].name.toUpperCase()),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.teal,
          value:  widget.rivals[index].isAvailable,
          onChanged: (bool value) {
            setState(() {
              widget.rivals[index].isAvailable = value;
              widget.rivals[index].save();
            });
            widget.addRival(widget.rivals[index].name, value);

          },
        ),
    ):Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
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
            "Danh sách trống",
            style: TextStyle(color: Colors.grey
                , fontSize: 17),
          ),
        ],
      ),
    );
  }
}

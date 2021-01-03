import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';
import 'package:sp_2021/feature/highlight/presentation/blocs/highlight_bloc.dart';
class SaveButton extends StatelessWidget {
  final List<HighlightEntity> highlights;

  const SaveButton({Key key, this.highlights}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 30,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () {
            BlocProvider.of<HighlightBloc>(context).add(HighlightValidateForm(highlights: highlights));
          },
          borderRadius: BorderRadius.circular(5),
          child: Center(
            child: Text(
              'LƯU',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff008319),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

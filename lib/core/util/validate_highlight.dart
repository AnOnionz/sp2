import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';

class ValidateHighlight {
  Future<Either<Failure, List<HighlightEntity>>> validateForm(
      List<HighlightEntity> highlights) async {
    for (int i = 0; i < highlights.length; i++) {
      if (highlights[i].content.length == 0) {
        return Left(ContentFailure(message: 'Chưa nhập ' + highlights[i].title));
      }
      if (highlights[i].content.split('').where((element) {
        if (element == "|") return true;
        if (element == "@") return true;
        if (element == "'") return true;
        if (element == "=") return true;
        if (element == "/") return true;
        if (element == "+") return true;
        if (element == "-") return true;
        if (element == "%") return true;
        if (element == "&") return true;
        if (element == "*") return true;
        return false;
      })
          .toList()
          .length > 0) {
        return Left(ContentFailure(message: highlights[i].title +
            ' chứa kí tự không hợp lệ (@|=*${"'"}/+&-%)'));
      }
      if (highlights[i].images.length == 0 && i != 4) {
        return Left(NoImageFailure());
      }
    }
    return Right(highlights);
  }
}
import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/core/util/validate_highlight.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';

class HighlightValidateUseCase extends UseCase<List<HighlightEntity>,List<HighlightEntity>>{

  @override
  Future<Either<Failure, List<HighlightEntity>>> call(List<HighlightEntity> params) async {
    return await ValidateHighlight().validateForm(params);
  }

}
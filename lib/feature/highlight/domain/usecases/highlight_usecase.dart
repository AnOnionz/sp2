import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';
import 'package:sp_2021/feature/highlight/domain/repositories/highlight_repository.dart';

class HighLightUseCase extends UseCase<bool, HighlightParams>{
  final HighlightRepository repository;

  HighLightUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(HighlightParams params) async{
    return await repository.uploadToServer(highlights: params.highlights);
  }

}
class HighlightParams extends Params{
  final HighlightCacheEntity highlights;

  HighlightParams({this.highlights});
}
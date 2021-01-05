import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';

abstract class HighlightRepository {
  Future<Either<Failure, bool>> uploadToServer({HighlightCacheEntity highlights});
  Future<void> syncHighlight();
  Future<bool> hasSync();

}
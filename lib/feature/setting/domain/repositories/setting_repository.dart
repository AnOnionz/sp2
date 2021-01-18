import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/setting/domain/entities/update_entity.dart';

abstract class SettingRepository {
  Future<Either<Failure, UpdateEntity>> checkVersion();
}

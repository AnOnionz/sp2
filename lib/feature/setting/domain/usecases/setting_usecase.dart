import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/setting/domain/entities/update_entity.dart';
import 'package:sp_2021/feature/setting/domain/repositories/setting_repository.dart';

class SettingUseCase extends UseCase<UpdateEntity, NoParams>{
  final SettingRepository repository;

  SettingUseCase({this.repository});
  @override
  Future<Either<Failure, UpdateEntity>> call(NoParams params) async {
    return await repository.checkVersion();
  }

}

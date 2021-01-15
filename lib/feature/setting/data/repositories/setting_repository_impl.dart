import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/setting/data/datasources/setting_remote_data_source.dart';
import 'package:sp_2021/feature/setting/domain/entities/update_entity.dart';
import 'package:sp_2021/feature/setting/domain/repositories/setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingRemoteDataSource remote;

  SettingRepositoryImpl({this.remote});
  @override
  Future<Either<Failure, UpdateEntity>> checkVersion() async {
    try{
      final updateEntity = await remote.checkVersion();
      return Right(updateEntity);
    }on InternetException catch(_){
      return Left(InternetFailure());
    }on InternalException catch(_){
      return Left(InternalFailure());
    }
  }

}
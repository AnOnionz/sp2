import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/send_requirement/data/datasources/send_requirement_local_data_source.dart';
import 'package:sp_2021/feature/send_requirement/data/datasources/send_requirement_remote_data_source.dart';
import 'package:sp_2021/feature/send_requirement/domain/repositories/send_requirement_repository.dart';

class SendRequirementRepositoryImpl implements SendRequirementRepository {
  final SendRequirementRemoteDataSource remote;
  final SendRequirementLocalDataSource local;
  final NetworkInfo networkInfo;

  SendRequirementRepositoryImpl({this.remote, this.local, this.networkInfo});
  @override
  Future<Either<Failure, bool>> sendRequirement({String message}) async {
    if (await networkInfo.isConnected) {
      try {
        await remote.sendRequirement(message: message);
        return Right(true);
      } on InternetException catch (_) {
        await local.cacheRequirement(message);
        return Left(InternetFailure());
      } on InternalException catch (_) {
        await local.cacheRequirement(message);
        return Left(InternalFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      }
    } else {
      await local.cacheRequirement(message);
      return Left(InternetFailure());
    }
  }
  @override
  Future<void> syncRequirement() async{
    if(await hasSync()) {
      final data = local.fetchRequirement();
      print(data);
      for (int i = 0; i < data.length; i++) {
        await remote.sendRequirement(message: data[i]);
        await local.clearRequirement();
      }
    }
  }

  @override
  Future<bool> hasSync() async{
    return local.isRequireSync();
  }
}
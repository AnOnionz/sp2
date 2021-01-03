import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/highlight/data/datasources/highlight_local_datasource.dart';
import 'package:sp_2021/feature/highlight/data/datasources/highlight_remote_datasource.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/highlight/domain/repositories/highlight_repository.dart';

class HighlightRepositoryImpl implements HighlightRepository {
  final HighlightRemoteDataSource remote;
  final HighLightLocalDataSource local;
  final DashBoardLocalDataSource dashboardLocal;
  final NetworkInfo networkInfo;

  HighlightRepositoryImpl(
      {this.remote, this.local, this.networkInfo, this.dashboardLocal});

  @override
  Future<Either<Failure, bool>> uploadToServer(
      {HighlightCacheEntity highlights}) async {
    final dataToday = await dashboardLocal.dataToday;
    if (dataToday.checkIn != true) {
      return Left(CheckInNullFailure(
          message: "Phải chấm công trước khi nhập thông tin cuối ngày"));
    }
    if (await networkInfo.isConnected) {
      try {
        final success = await remote.uploadToServer(highlights);
        if (success) {
          await dashboardLocal.cacheDataToday(highLight: true, highlightCacheEntity: highlights);
        }
        return Right(success);
      } on UnAuthenticateException catch (_) {
        await local.cacheHighlight(highlights);
        await dashboardLocal.cacheDataToday(highLight: true, highlightCacheEntity: highlights);
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (_) {
        await dashboardLocal.cacheDataToday(highLight: true, highlightCacheEntity: highlights);
        await local.cacheHighlight(highlights);
        return Left(InternalFailure());
      } on InternetException catch (_) {
        await dashboardLocal.cacheDataToday(highLight: true, highlightCacheEntity: highlights);
        await local.cacheHighlight(highlights);
        return Left(NotInternetItWillCacheLocalFailure());
      }
    }
    else {
      await local.cacheHighlight(highlights);
      await dashboardLocal.cacheDataToday(highLight: true, highlightCacheEntity: highlights);
      return Left(NotInternetItWillCacheLocalFailure());
    }
  }


  @override
  Future<void> syncHighlight() async{
    if(await hasSync()) {
      final data = local.fetchHighlight();
      print(data);
      final sync = await remote.uploadToServer(data);
      if (sync == true) {
        await local.clearHighlight();
      }
    }
  }

  @override
  Future<bool> hasSync() async{
    return local.isRequireSync();
  }

}
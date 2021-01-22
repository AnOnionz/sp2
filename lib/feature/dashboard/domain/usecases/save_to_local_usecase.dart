import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class SaveDataToLocalUseCase implements UseCase<bool, NoParams>{
  final DashboardRepository repository;
  final NetworkInfo networkInfo;

  SaveDataToLocalUseCase({this.repository, this.networkInfo});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await repository.saveProductFromServer();
        await repository.saveRivalProductFromServer();
        await repository.saveGiftFromServer();
        await repository.saveGiftStrongbowFromServer();
        await repository.saveSetGiftFromServer();
        await repository.saveSetGiftSBFromServer();
        await repository.saveSetGiftCurrentFromServer();
        await repository.saveSetGiftSBCurrentFromServer();
        await repository.saveKpiFromServer();

        return Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (_) {
        return Left(InternalFailure());
      }
    }else{
      return Left(InternetFailure());
    }
  }
}
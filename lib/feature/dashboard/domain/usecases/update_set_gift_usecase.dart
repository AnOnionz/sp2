import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class UpdateDataUseCase extends UseCase<bool, NoParams>{
  final DashboardRepository repository;
  final NetworkInfo networkInfo;

  UpdateDataUseCase({this.repository, this.networkInfo});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await repository.saveSetGiftFromServer();
        await repository.saveSetGiftSBFromServer();
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
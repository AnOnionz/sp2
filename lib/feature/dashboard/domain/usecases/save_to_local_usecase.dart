import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class SaveDataToLocalUseCase implements UseCase<bool, NoParams>{
  final DashboardRepository repository;

  SaveDataToLocalUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
      await repository.saveProductFromServer() ;
      await repository.saveRivalProductFromServer();
      await repository.saveGiftFromServer() ;
      await repository.saveGiftStrongbowFromServer();
      await repository.saveSetGiftCurrentFromServer();
      await repository.saveSetGiftFromServer() ;
      await repository.saveSetGiftSBFromServer() ;
      await repository.saveSetGiftSBCurrentFromServer() ;
      return Right(true);

  }
}
import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class RefreshDataUseCase implements UseCase<bool, NoParams>{
  final DashboardRepository repository;

  RefreshDataUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
//    return await repository.saveProductFromServer().whenComplete(() async
//    => await repository.saveRivalProductFromServer()).whenComplete(() async
//    => await repository.saveProductFromServer().whenComplete(() async
//    => await repository.saveGiftFromServer())).whenComplete(() async
//    => await repository.saveGiftStrongbowFromServer()).whenComplete(() async
//    => await repository.saveSetGiftFromServer()).whenComplete(() async
//    => await repository.saveProductFromServer()).whenComplete(() async
//    =>  await repository.saveSetGiftSBFromServer()).whenComplete(() async
//    =>  await repository.saveKpiFromServer());
    await repository.saveProductFromServer() ;
    await repository.saveRivalProductFromServer();
    await repository.saveGiftFromServer() ;
    await repository.saveGiftStrongbowFromServer();
    await repository.saveSetGiftFromServer() ;
    await repository.saveSetGiftSBFromServer() ;
    await repository.saveKpiFromServer();
    return Right(true);
  }
}
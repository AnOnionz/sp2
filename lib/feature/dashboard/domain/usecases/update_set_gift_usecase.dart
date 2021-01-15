import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/dashboard/domain/repositories/dashboard_repository.dart';

class UpdateSetGiftUseCase extends UseCase<bool, NoParams>{
  final DashboardRepository repository;

  UpdateSetGiftUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async  {
    await repository.saveSetGiftFromServer() ;
    await repository.saveSetGiftSBFromServer() ;
    return Right(true);
  }

}
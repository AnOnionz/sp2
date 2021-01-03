import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/sync_data/domain/repositories/sync_repository.dart';

class SyncUseCase extends UseCase<bool, NoParams>{
  final SyncRepository repository;

  SyncUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
   return await repository.synchronous();
  }

}
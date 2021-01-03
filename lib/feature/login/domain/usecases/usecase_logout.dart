import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';

import 'package:sp_2021/feature/login/domain/repositories/login_repository.dart';

class UseCaseLogout implements UseCase<bool, NoParams>{
  final LoginRepository repository;

  UseCaseLogout({this.repository});
  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async  {
    return await repository.logout();

  }
}
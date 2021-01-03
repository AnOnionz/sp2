import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/login/domain/repositories/login_repository.dart';

class UsecaseLogin implements UseCase<LoginEntity, LoginParams>{
  final LoginRepository repository;

  UsecaseLogin({this.repository});
  @override
  Future<Either<Failure, LoginEntity>> call(LoginParams params) async {
      return await repository.login(username: params.username, password: params.password, deviceId: params.deviceid);
  }

}
class LoginParams extends Params{
  final String username;
  final String password;
  final String deviceid;

  LoginParams({this.username, this.password, this.deviceid});

  @override
  List<Object> get props => [username, password, deviceid];

}
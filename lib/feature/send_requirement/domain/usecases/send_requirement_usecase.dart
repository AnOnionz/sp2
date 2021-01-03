import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/send_requirement/domain/repositories/send_requirement_repository.dart';

class SendRequirementUseCase extends UseCase<bool, SendRequirementParams>{
  final SendRequirementRepository repository;

  SendRequirementUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(SendRequirementParams params) async {
   return await repository.sendRequirement(message: params.message);
  }

}
class SendRequirementParams extends Params{
  final String message;

  SendRequirementParams({this.message});
}
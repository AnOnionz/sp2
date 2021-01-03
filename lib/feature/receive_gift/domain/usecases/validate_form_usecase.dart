import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/core/util/validate_form.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';

class ValidateFormUseCase extends UseCase<void,ValidateFormParams>{
  final ValidateForm validateForm;

  ValidateFormUseCase({this.validateForm});
  @override
  Future<Either<Failure, FormEntity>> call(ValidateFormParams params) async{
   return await validateForm.validateForm(params.form);
  }

}
class ValidateFormParams extends Params{
  final FormEntity form;

  ValidateFormParams({this.form});
}
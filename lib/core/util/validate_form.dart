import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/form_entity.dart';

class ValidateForm {

  Future<Either<Failure, FormEntity>> validateForm(FormEntity form) async {
    // name
    if(form.customer.name == null || form.customer.name.replaceAll(" ", "") == '' || form.customer.name.split('').where((element) {
      if(element == "." || element == "," || element == "!" || element == "|" || element == "|" || element == "@" || element == "'" || element == "=" ||  element == "/" || element == "+" || element == "-" || element == "%" || element == "*" || element == "&") return true;
      return false;
    }).toList().length > 0 || form.customer.name == ""){
      return Left(NameFailure());
    }
    // phone
    print(form.customer.phoneNumber);
    if(form.customer.phoneNumber == null || form.customer.phoneNumber.length != 10 || !RegExp(r'^0[^01]([0-9]+)').hasMatch(form.customer.phoneNumber)){
      print('phone error');
      return Left(PhoneFailure());
    }
    if(form.products.map((e) => e.buyQty).toList().fold(0, (previousValue, element) => previousValue + element) == 0){
      return Left(ValueFailure());
    }
//    if(form.images.length == 0){
//      return Left(NoImageFailure());
//    }
    return Right(form);

  }
}

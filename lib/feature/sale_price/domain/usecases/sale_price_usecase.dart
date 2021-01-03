import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/sale_price/domain/repositories/sale_price_repository.dart';

class SalePriceUseCase extends UseCase<bool, SalePriceParams>{
  final SalePriceRepository repository;

  SalePriceUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(SalePriceParams params) async {
    return await repository.updateSalePrice(products: params.products);
  }

}
class SalePriceParams extends Params{
  final List<ProductEntity> products;

  SalePriceParams({this.products});
}
import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/rival_sale_price/domain/repositories/rival_sale_price_repository.dart';

class RivalSalePriceUseCase extends UseCase<bool, RivalSalePriceParams>{
  final RivalSalePriceRepository repository;

  RivalSalePriceUseCase({this.repository});
  @override
  Future<Either<Failure, bool>> call(RivalSalePriceParams params) async {
    return await repository.updateRivalSalePrice(rivals: params.rivals);
  }

}
class RivalSalePriceParams extends Params{
  final List<RivalProductEntity> rivals;

  RivalSalePriceParams({this.rivals});
}
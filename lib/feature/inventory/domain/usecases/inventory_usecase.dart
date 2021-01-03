import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/feature/inventory/domain/repositories/inventory_repository.dart';

class UpdateInventory extends UseCase<bool, InventoryParams>{
  final InventoryRepository repository;

  UpdateInventory({this.repository});
  @override
  Future<Either<Failure, bool>> call(InventoryParams params) async {
    return await repository.updateInventory(products: params.products);
  }

}
class InventoryParams extends Params{
  final List<ProductEntity> products;

  InventoryParams({this.products});
}
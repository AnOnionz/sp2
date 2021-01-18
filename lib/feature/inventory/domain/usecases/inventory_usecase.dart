import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/usecases/usecase.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/inventory/domain/repositories/inventory_repository.dart';

class UpdateInventory extends UseCase<bool, InventoryParams>{
  final InventoryRepository repository;

  UpdateInventory({this.repository});
  @override
  Future<Either<Failure, bool>> call(InventoryParams params) async {
    return await repository.saveInventoryToServer(inventory: params.inventory);
  }

}
class InventoryParams extends Params{
  final InventoryEntity inventory;

  InventoryParams({this.inventory});
}
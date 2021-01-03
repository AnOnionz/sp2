import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/dashboard/data/datasources/dashboard_local_datasouce.dart';
import 'package:sp_2021/feature/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:sp_2021/feature/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository{
  final DashBoardLocalDataSource local;
  final InventoryRemoteDataSource remote;

  InventoryRepositoryImpl({this.local, this.remote});
  @override
  Future<Either<Failure, bool>> updateInventory({List<ProductEntity> products}) async{
    try{
      local.cacheProducts(products: products);
      await remote.updateInventory(products);
      return Right(true);
    }on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }on UnAuthenticateException catch(error){
      return Left(UnAuthenticateFailure());
    }
  }

}
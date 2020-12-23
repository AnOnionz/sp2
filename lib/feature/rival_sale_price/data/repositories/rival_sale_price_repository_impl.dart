import 'package:dartz/dartz.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/Exception.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/feature/sale_price/data/datasources/sale_price_remote_data_source.dart';
import 'package:sp_2021/feature/sale_price/domain/repositories/sale_price_repository.dart';

class SalePriceRepositoryImpl implements SalePriceRepository{
  final SalePriceRemoteDataSource remote;

  SalePriceRepositoryImpl({this.remote});

  @override
  Future<Either<Failure, bool>> updateSalePrice({List<ProductEntity> products}) async {
    try {
      final update = await remote.updateSalePrice(products: products);
      return Right(update);
    } on ServerException catch(error){
      return Left(ServerFailure(message: error.message));
    } on ResponseException catch(error){
      return Left(ResponseFailure(message: error.message));
    }
  }

}
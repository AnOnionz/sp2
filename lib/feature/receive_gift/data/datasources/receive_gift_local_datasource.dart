import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';

abstract class ReceiveGiftLocalDataSource{
  Future<Either<Failure, List<Gift>>> ExportGift({List<ProductEntity> products, CustomerEntity customer});
}
class ReceiveGiftLocalDataSourceImpl implements ReceiveGiftLocalDataSource{
  final SecureStorage storage;

  ReceiveGiftLocalDataSourceImpl(this.storage);
  @override
  Future<Either<Failure, List<Gift>>> ExportGift({List<ProductEntity> products, CustomerEntity customer}) {
    List<Gift> giftsReceive = [];
    products.forEach((productEntity) {
      // lay set qua hien tai
      //final List<GiftEntity> setGift = storage.readSetGiftCurrent();
      //giftsReceive.addAll(productEntity.getGift(setGift));
      // check turn wheel 5 in day
      // return GiftCanReceive entity
      // have list gift receive. sort by gift->wheel

    });

  }

}
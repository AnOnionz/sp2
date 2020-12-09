import 'package:dartz/dartz.dart';
import 'package:sp_2021/app/entities/gift_entity.dart';
import 'package:sp_2021/app/entities/product_entity.dart';
import 'package:sp_2021/core/error/failure.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/gifts_receive.dart';

abstract class ReceiveGiftLocalDataSource{
  Future<Either<Failure, GiftCanReceive>> ExportGift({List<ProductEntity> products, CustomerEntity customer});
}
class ReceiveGiftLocalDataSourceImpl implements ReceiveGiftLocalDataSource{
  final SecureStorage storage;

  ReceiveGiftLocalDataSourceImpl(this.storage);
  @override
  Future<Either<Failure, GiftCanReceive>> ExportGift({List<ProductEntity> products, CustomerEntity customer}) {
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
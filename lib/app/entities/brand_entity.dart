import 'package:equatable/equatable.dart';
import 'package:sp_2021/app/entities/product_entity.dart';

class BrandEntity extends Equatable{
  final int id;
  final String name;
  final int brandId;// so luong ban dau
  final int remainAmount;// so luong con lai hien tai
  final List<ProductEntity> products;
  final String type;

  BrandEntity({this.id, this.name, this.brandId, this.remainAmount, this.products, this.type});

  @override
  List<Object> get props => [name];

}


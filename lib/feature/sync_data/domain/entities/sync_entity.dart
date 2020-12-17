import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'sync_entity.g.dart';

@HiveType(typeId: 6)
class SyncEntity extends Equatable with HiveObject {
  @HiveField(0)
  int nonSynchronized;
  @HiveField(1)
  int synchronized;
  @HiveField(2)
  int imageNonSynchronized;
  @HiveField(3)
  int imageSynchronized;

  SyncEntity(
      {this.nonSynchronized,
      this.synchronized,
      this.imageNonSynchronized,
      this.imageSynchronized});

  @override
  List<Object> get props =>
      [nonSynchronized, synchronized, imageSynchronized, imageNonSynchronized];
}

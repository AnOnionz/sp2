import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'sync_entity.g.dart';

@HiveType(typeId: 6)
// ignore: must_be_immutable
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
  String toString() {
    return 'SyncEntity{nonSynchronized: $nonSynchronized, synchronized: $synchronized, imageNonSynchronized: $imageNonSynchronized, imageSynchronized: $imageSynchronized}';
  }

  @override
  List<Object> get props =>
      [nonSynchronized, synchronized, imageSynchronized, imageNonSynchronized];

}

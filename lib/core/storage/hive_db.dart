import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_entity.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/receive_gift_entity.dart';
import 'package:sp_2021/feature/sync_data/domain/entities/sync_entity.dart';

  Future<void> init() async {
    var dir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter<GiftEntity>(GiftEntityAdapter());
    Hive.registerAdapter<SetGiftEntity>(SetGiftEntityAdapter());
    Hive.registerAdapter<CustomerEntity>(CustomerEntityAdapter());
    Hive.registerAdapter<FcmEntity>(FcmEntityAdapter());
    Hive.registerAdapter<HighlightEntity>(HighlightEntityAdapter());
    Hive.registerAdapter<InventoryEntity>(InventoryEntityAdapter());
    Hive.registerAdapter<ReceiveGiftEntity>(ReceiveGiftEntityAdapter());
    Hive.registerAdapter<SyncEntity>(SyncEntityAdapter());
    Hive.registerAdapter<ProductEntity>(ProductEntityAdapter());
    Hive.registerAdapter<RivalProductEntity>(RivalProductEntityAdapter());
    await Hive.openBox<ProductEntity>(PRODUCT_BOX);
    await Hive.openBox<GiftEntity>(GIFT_BOX);
    await Hive.openBox<SetGiftEntity>(SET_GIFT_BOX);
    await Hive.openBox<SetGiftEntity>(SET_GIFT_CURRENT_BOX);
    await Hive.openBox<CustomerEntity>(CUSTOMER_BOX);
    await Hive.openBox<HighlightEntity>(HIGHLIGHT_BOX);
    await Hive.openBox<InventoryEntity>(INVENTORY_BOX);
    await Hive.openBox<RivalProductEntity>(RIVAL_PRODUCT_BOX);
    await Hive.openBox<ReceiveGiftEntity>(GIFT_RECEIVE);
    await Hive.openBox<FcmEntity>(NOTIFICATION_BOX);
    await Hive.openBox<SyncEntity>(SYNC_BOX);


  }
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/entities/gift_entity.dart';
import 'package:sp_2021/core/entities/set_gift_entity.dart';
import 'package:sp_2021/core/entities/product_entity.dart';
import 'package:sp_2021/core/entities/rival_product_entity.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/today_data_entity.dart';
import 'package:sp_2021/feature/highlight/domain/entities/highlight_cache_entity.dart';
import 'package:sp_2021/feature/inventory/domain/entities/inventory_entity.dart';
import 'package:sp_2021/feature/login/presentation/blocs/authentication_bloc.dart';
import 'package:sp_2021/feature/notification/domain/entities/fcm_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_gift_entity.dart';
import 'package:sp_2021/feature/sync_data/domain/entities/sync_entity.dart';

  Future<void> init() async {
    var dir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter<GiftEntity>(GiftEntityAdapter());
    Hive.registerAdapter<SetGiftEntity>(SetGiftEntityAdapter());
    Hive.registerAdapter<CustomerGiftEntity>(CustomerGiftEntityAdapter());
    Hive.registerAdapter<CustomerEntity>(CustomerEntityAdapter());
    Hive.registerAdapter<FcmEntity>(FcmEntityAdapter());
    Hive.registerAdapter<HighlightCacheEntity>(HighlightCacheEntityAdapter());
    Hive.registerAdapter<InventoryEntity>(InventoryEntityAdapter());
    Hive.registerAdapter<SyncEntity>(SyncEntityAdapter());
    Hive.registerAdapter<ProductEntity>(ProductEntityAdapter());
    Hive.registerAdapter<RivalProductEntity>(RivalProductEntityAdapter());
    Hive.registerAdapter<DataTodayEntity>(DataTodayEntityAdapter());
  }
  Future<void> initDB() async {
    await Hive.openBox<ProductEntity>(AuthenticationBloc.outlet.id.toString() + PRODUCT_BOX);
    await Hive.openBox<RivalProductEntity>(AuthenticationBloc.outlet.id.toString() + RIVAL_PRODUCT_BOX);
    await Hive.openBox<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_BOX);
    await Hive.openBox<GiftEntity>(AuthenticationBloc.outlet.id.toString() + GIFT_STRONGBOW_BOX);
    await Hive.openBox<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_BOX);
    await Hive.openBox<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_STRONGBOW_BOX);
    await Hive.openBox<SetGiftEntity>(AuthenticationBloc.outlet.id.toString() + SET_GIFT_CURRENT_BOX);
    await Hive.openBox<HighlightCacheEntity>(AuthenticationBloc.outlet.id.toString() + HIGHLIGHT_BOX);
    await Hive.openBox<InventoryEntity>(AuthenticationBloc.outlet.id.toString() + INVENTORY_BOX);
    await Hive.openBox<List<dynamic>>(AuthenticationBloc.outlet.id.toString() + SALE_PRICE_BOX);
    await Hive.openBox<List<dynamic>>(AuthenticationBloc.outlet.id.toString() + RIVAL_SALE_PRICE_BOX);
    await Hive.openBox<CustomerGiftEntity>(AuthenticationBloc.outlet.id.toString() + CUSTOMER_GIFT_BOX);
    await Hive.openBox<FcmEntity>(AuthenticationBloc.outlet.id.toString() + NOTIFICATION_BOX);
    await Hive.openBox<String>(AuthenticationBloc.outlet.id.toString() + SEND_REQUIREMENT);
    await Hive.openBox<SyncEntity>(AuthenticationBloc.outlet.id.toString() + SYNC_BOX);
    await Hive.openBox<DataTodayEntity>(AuthenticationBloc.outlet.id.toString() + DATA_DAY);
    print(MyDateTime.today);
    await Hive.openBox<CustomerEntity>(AuthenticationBloc.outlet.id.toString() + MyDateTime.today + CUSTOMER_BOX);

  }
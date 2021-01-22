
abstract class DashboardRepository {

  Future<void> saveProductFromServer();
  Future<void> saveRivalProductFromServer();
  Future<void> saveGiftFromServer();
  Future<void> saveGiftStrongbowFromServer();
  Future<void> saveSetGiftFromServer();
  Future<void> saveSetGiftSBFromServer();
  Future<void> saveSetGiftCurrentFromServer();
  Future<void> saveSetGiftSBCurrentFromServer();
  Future<void> saveKpiFromServer();

}


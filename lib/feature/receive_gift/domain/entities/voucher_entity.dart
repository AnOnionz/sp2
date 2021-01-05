class VoucherEntity {
  final String phone;
  final int qty;

  VoucherEntity({this.phone, this.qty});

  @override
  String toString() {
    return 'VoucherEntity{phone: $phone, qty: $qty}';
  }
}
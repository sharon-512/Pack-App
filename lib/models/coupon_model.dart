
class Coupon {
  final String code;
  final String value;
  final String expiry;

  Coupon({
    required this.code,
    required this.value,
    required this.expiry,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] ?? 'No Code',
      value: json['value'] ?? 'No Value',
      expiry: json['expiry'] ?? 'No Expiry',
    );
  }
}

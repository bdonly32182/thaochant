class ShippingProductModel {
  String shippingNo;
  String typeShipping;
  String orderId;
  DateTime shippingDate;
  ShippingProductModel({
    required this.shippingNo,
    required this.typeShipping,
    required this.orderId,
    required this.shippingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'shippingNo': shippingNo,
      'typeShipping': typeShipping,
      'orderId': orderId,
      'shippingDate': shippingDate.millisecondsSinceEpoch,
    };
  }

  factory ShippingProductModel.fromMap(Map<String, dynamic> map) {
    return ShippingProductModel(
      shippingNo: map['shippingNo'] ?? '',
      typeShipping: map['typeShipping'] ?? '',
      orderId: map['orderId'] ?? '',
      shippingDate: DateTime.fromMillisecondsSinceEpoch(map['shippingDate']),
    );
  }
}

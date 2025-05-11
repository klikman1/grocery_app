class CartProduct {
  final String cartProductId;
  final String productId;
  int quantity;
  bool isChecked;

  CartProduct({
    required this.cartProductId,
    required this.productId,
    required this.quantity,
    required this.isChecked,
  });

  // From DB to an Instance
  factory CartProduct.fromMap(String id, Map<String, dynamic> data) {
    return CartProduct(
      cartProductId: id,
      productId: data['productId'],
      quantity: data['quantity'],
      isChecked: data['isChecked'],
    );
  }

  // From code to DB
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'isChecked': isChecked,
    };
  }
}

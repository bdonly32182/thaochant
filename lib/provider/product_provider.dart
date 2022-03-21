import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  List<ProductCartModel> _products = [];

  List<ProductCartModel> get products => _products;

  addNewProduct(ProductCartModel product) {
    _products.insert(0, product);
    notifyListeners();
  }

  fetchsProduct(List<ProductCartModel> products) {
    _products = products;
    notifyListeners();
  }

  updateProduct(ProductCartModel food) {
    _products
        .where((element) =>
            element.productId == food.productId &&
            element.userId == food.userId)
        .map(
          (e) => {
            e.addtionMessage = food.addtionMessage,
            e.amount = food.amount,
            e.businessId = food.businessId,
            e.id = food.id,
            e.imageURL = food.imageURL,
            e.price = food.price,
            e.productId = food.productId,
            e.productName = food.productName,
            e.totalPrice = food.totalPrice,
            e.userId = food.userId,
          },
        )
        .toList();
    notifyListeners();
  }

  deleteProductId(String productId, userId) {
    _products.removeWhere((element) =>
        element.productId == productId && element.userId == userId);
    notifyListeners();
  }
}

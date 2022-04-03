import 'package:chanthaburi_app/models/sqlite/order_product.dart';

class CalculateShipping {
  /*แบบพัสดุ kg = 39 bath Q = 8600 */
  double calculateShipping(List<ProductCartModel> products) {
    double totalWidth = 0;
    double totalHeight = 0;
    double totalLong = 0;
    double totalWeight = 0;
    for (ProductCartModel product in products) {
      totalHeight += product.height;
      totalWeight += product.weight;
      totalLong += product.long;
      totalWidth += product.width;
    }
    double totalPriceCalSize = calSize(totalWidth, totalLong, totalHeight);
    double totalPriceCalWeight = calWeight(totalWeight);
    return totalPriceCalSize > totalPriceCalWeight ? totalPriceCalSize : totalPriceCalWeight;
  }
  double calSize(double totalWidth,totalLong,totalHeight){
    double volumn = (totalWidth * totalLong * totalHeight) / 1000000;
    return volumn * 8600;
  }
  double calWeight(double totalWeight){
    return totalWeight * 39;
  }
}

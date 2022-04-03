import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:flutter/foundation.dart';

class AddressProvider with ChangeNotifier {

  final List<ShippingModel> _address = [];

  List<ShippingModel> get address => _address;

  createAddress(ShippingModel address) {
    _address.insert(0,address);
    notifyListeners();
  }

  updateAddress(ShippingModel newAddress) {
    _address.removeAt(0);
    _address.insert(0,newAddress);
    notifyListeners();
  }
  deleteAddress(){
    _address.removeAt(0);
    notifyListeners();
  }
}
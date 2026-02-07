import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/shipping_address.dart';

class CheckoutProvider extends ChangeNotifier {
  ShippingAddress _address = ShippingAddress();
  bool _isAddressComplete = false;

  ShippingAddress get address => _address;
  bool get isAddressComplete => _isAddressComplete;

  CheckoutProvider() {
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressJson = prefs.getString('shipping_address');
    if (addressJson != null) {
      _address = ShippingAddress.fromJson(json.decode(addressJson));
      _isAddressComplete = true;
      notifyListeners();
    }
  }

  Future<void> saveAddress(ShippingAddress newAddress) async {
    _address = newAddress;
    _isAddressComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shipping_address', json.encode(_address.toJson()));
    notifyListeners();
  }
}

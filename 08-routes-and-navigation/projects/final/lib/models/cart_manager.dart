import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get totalCost => price * quantity;
}

enum DeliveryMode { delivery, pickup }

class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [];
  DeliveryMode _mode = DeliveryMode.pickup;
  DateTime? _timeOfPickupOrDelivery;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners(); // Уведомляем об изменениях
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void resetCart() {
    _items.clear();
    _mode = DeliveryMode.pickup;
    _timeOfPickupOrDelivery = null;
    notifyListeners();
  }

  CartItem itemAt(int index) {
    if (index >= 0 && index < _items.length) {
      return _items[index];
    } else {
      throw IndexError.withLength(index, _items.length);
    }
  }

  double get totalCost {
    return _items.fold(0.0, (sum, item) => sum + item.totalCost);
  }

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  void setMode(DeliveryMode mode) {
    _mode = mode;
    notifyListeners();
  }

  DeliveryMode get mode => _mode;

  void setTime(DateTime time) {
    _timeOfPickupOrDelivery = time;
    notifyListeners();
  }

  DateTime? get time => _timeOfPickupOrDelivery;
}

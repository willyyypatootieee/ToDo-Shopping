import 'package:flutter/material.dart';
import 'models/shopping_item.dart';

class ShoppingListModel extends ChangeNotifier {
  final List<ShoppingItem> _items = [];
  List<ShoppingItem> get items => List.unmodifiable(_items);

  void addItem(String name) {
    _items.add(ShoppingItem(name: name));
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void toggleItem(int index) {
    _items[index].isDone = !_items[index].isDone;
    notifyListeners();
  }

  void setItems(List<ShoppingItem> items) {
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'food.dart';

class FoodsState extends ChangeNotifier {
  final Box<Food> _scannedFoodsBox;
  final Box<Food> _favFoodsBox;

  FoodsState(this._scannedFoodsBox, this._favFoodsBox);

  List<Food> get scannedFoods => _scannedFoodsBox.values.toList();
  List<Food> get favoriteFoods => _favFoodsBox.values.toList();

  Future<void> addScannedFood(Food food) async {
    await _removeFoodFromBox(food, _scannedFoodsBox);
    await _scannedFoodsBox.add(food);
    notifyListeners();
  }

  Future<void> deleteScannedFood(Food food) async {
    await _removeFoodFromBox(food, _scannedFoodsBox);
    notifyListeners();
  }

  Future<void> addFavoriteFood(Food food) async {
    await _removeFoodFromBox(food, _favFoodsBox);
    await _favFoodsBox.add(food.copyWith()); // Need to copy the object to be able to put it in two boxes
    notifyListeners();
  }

  Future<void> removeFavoriteFood(Food food) async {
    await _removeFoodFromBox(food, _favFoodsBox);
    notifyListeners();
  }

  Future<void> _removeFoodFromBox(Food food, Box<Food> box) async {
    final previousFoodIdx = box.values.toList().indexWhere((e) => e.barcode == food.barcode);
    if (previousFoodIdx != -1) {
      await box.deleteAt(previousFoodIdx);
    }
  }
}

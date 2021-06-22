import 'package:hive/hive.dart';

import 'food.dart';

class FoodRepository {
  final Box<Food> _scannedFoodsBox;
  final Box<Food> _favFoodsBox;

  FoodRepository(this._scannedFoodsBox, this._favFoodsBox);

  Future<void> addScannedFood(Food food) async {
    await _removeFoodFromBox(food, _scannedFoodsBox);
    await _scannedFoodsBox.add(food);
  }

  Future<void> deleteScannedFood(Food food) async {
    await _removeFoodFromBox(food, _scannedFoodsBox);
  }

  Future<void> addFavoriteFood(Food food) async {
    await _removeFoodFromBox(food, _favFoodsBox);
    await _favFoodsBox.add(food.copyWith()); // Need to copy the object to be able to put it in two boxes
  }

  Future<void> removeFavoriteFood(Food food) async {
    await _removeFoodFromBox(food, _favFoodsBox);
  }

  Future<void> _removeFoodFromBox(Food food, Box<Food> box) async {
    final previousFoodIdx = box.values.toList().indexWhere((e) => e.barcode == food.barcode);
    if (previousFoodIdx != -1) {
      await box.deleteAt(previousFoodIdx);
    }
  }
}

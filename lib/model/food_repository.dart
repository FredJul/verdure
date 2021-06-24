import 'package:ecoscore/api/open_food_facts_api.dart';
import 'package:hive/hive.dart';

import 'food.dart';

class FoodRepository {
  final Box<Food> _scannedFoodsBox;
  final Box<Food> _favFoodsBox;

  FoodRepository(this._scannedFoodsBox, this._favFoodsBox);

  Future<Food?> refreshFood(String barcode) async {
    final food = await OpenFoodFactsApi.getFood(barcode);

    if (food != null) {
      for (int i = 0; i < _scannedFoodsBox.length; i++) {
        if (_scannedFoodsBox.getAt(i)!.barcode == barcode) {
          await _scannedFoodsBox.putAt(i, food);
          break;
        }
      }

      for (int i = 0; i < _favFoodsBox.length; i++) {
        if (_favFoodsBox.getAt(i)!.barcode == barcode) {
          await _favFoodsBox.putAt(i, food);
          break;
        }
      }
    }

    return food;
  }

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

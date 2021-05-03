import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Food extends HiveObject {
  Food({
    required this.barcode,
    required this.name,
    this.brands,
    this.imageFrontSmallUrl,
    this.imageFrontUrl,
    this.imageIngredientsUrl,
    this.ecoscoreGrade,
    this.ecoscoreScore,
    this.nutriscoreGrade,
    this.quantity,
    required this.categoryTags,
  });

  @HiveField(0)
  String barcode;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? brands;

  @HiveField(3)
  String? imageFrontSmallUrl;

  @HiveField(4)
  String? imageFrontUrl;

  @HiveField(5)
  String? imageIngredientsUrl;

  @HiveField(6)
  String? ecoscoreGrade;

  @HiveField(7)
  double? ecoscoreScore;

  @HiveField(8)
  String? nutriscoreGrade;

  @HiveField(9)
  String? quantity;

  @HiveField(10)
  List<String> categoryTags;
}

class FoodsState extends ChangeNotifier {
  final Box<Food> _box;

  FoodsState(this._box);

  List<Food> get scannedFoods {
    final orgas = _box.values.toList();
    return orgas;
  }

  Future<void> add(Food food) async {
    final previousFoodIdx = scannedFoods.indexWhere((e) => e.barcode == food.barcode);
    if (previousFoodIdx != -1) {
      await _box.deleteAt(previousFoodIdx);
    }

    await _box.add(food);
    notifyListeners();
  }
}

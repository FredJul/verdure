import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:hive/hive.dart';

part 'food.g.dart';

@CopyWith()
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

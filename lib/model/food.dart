import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:ecoscore/common/extensions.dart';
import 'package:hive/hive.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';

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
    this.packagingScore,
    this.productionImpactScore,
    this.transportationImpactScore,
    this.nutriscoreGrade,
    required this.sugarsLevel,
    required this.fatLevel,
    required this.saturatedFatLevel,
    required this.saltLevel,
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
  double? packagingScore;

  @HiveField(9)
  double? productionImpactScore;

  @HiveField(10)
  double? transportationImpactScore;

  @HiveField(11)
  String? nutriscoreGrade;

  @HiveField(12)
  Level sugarsLevel;

  @HiveField(13)
  Level fatLevel;

  @HiveField(14)
  Level saturatedFatLevel;

  @HiveField(15)
  Level saltLevel;

  @HiveField(16)
  String? quantity;

  @HiveField(17)
  List<String> categoryTags;
}

class NutrientLevelAdapter extends TypeAdapter<Level> {
  @override
  final typeId = 100;

  @override
  Level read(BinaryReader reader) {
    final enumValue = reader.read() as String;
    return Level.values.firstWhereOrNull((e) => e.value == enumValue) ?? Level.UNDEFINED;
  }

  @override
  void write(BinaryWriter writer, Level l) {
    writer.write(l.value);
  }
}

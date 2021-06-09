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
    this.ingredientsScore,
    this.packagingScore,
    this.transportationScore,
    this.missingEcoscoreDataWarning = false,
    this.nutriscoreGrade,
    this.sugarsQuantity,
    this.fatQuantity,
    this.saturatedFatQuantity,
    this.saltQuantity,
    this.sugarsLevel,
    this.fatLevel,
    this.saturatedFatLevel,
    this.saltLevel,
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
  Grade? ecoscoreGrade;

  @HiveField(7)
  double? ingredientsScore;

  @HiveField(8)
  double? packagingScore;

  @HiveField(9)
  double? transportationScore;

  @HiveField(10)
  bool missingEcoscoreDataWarning;

  @HiveField(11)
  Grade? nutriscoreGrade;

  @HiveField(12)
  double? sugarsQuantity;

  @HiveField(13)
  double? fatQuantity;

  @HiveField(14)
  double? saturatedFatQuantity;

  @HiveField(15)
  double? saltQuantity;

  @HiveField(16)
  ImpactLevel? sugarsLevel;

  @HiveField(17)
  ImpactLevel? fatLevel;

  @HiveField(18)
  ImpactLevel? saturatedFatLevel;

  @HiveField(19)
  ImpactLevel? saltLevel;

  @HiveField(20)
  String? quantity;

  @HiveField(21)
  List<String> categoryTags;

  ImpactLevel? get ingredientsImpact => _scoreToImpactLevel(ingredientsScore);
  ImpactLevel? get packagingImpact => _scoreToImpactLevel(packagingScore);
  ImpactLevel? get transportationImpact => _scoreToImpactLevel(transportationScore);

  ImpactLevel? _scoreToImpactLevel(double? score) {
    if (score == null) {
      return null;
    } else if (score < 33) {
      return ImpactLevel.high;
    } else if (score > 66) {
      return ImpactLevel.low;
    } else {
      return ImpactLevel.moderate;
    }
  }
}

enum Grade { a, b, c, d, e, notApplicable }

extension GradeExtension on Grade {
  String get letter {
    switch (this) {
      case Grade.a:
        return 'a';
      case Grade.b:
        return 'b';
      case Grade.c:
        return 'c';
      case Grade.d:
        return 'd';
      case Grade.e:
        return 'e';
      case Grade.notApplicable:
        throw UnsupportedError;
    }
  }
}

class GradeAdapter extends TypeAdapter<Grade> {
  @override
  final typeId = 100;

  @override
  Grade read(BinaryReader reader) {
    return Grade.values[reader.read() as int];
  }

  @override
  void write(BinaryWriter writer, Grade l) {
    writer.write(l.index);
  }
}

enum ImpactLevel { low, moderate, high }

class ImpactLevelAdapter extends TypeAdapter<ImpactLevel> {
  @override
  final typeId = 101;

  @override
  ImpactLevel read(BinaryReader reader) {
    return ImpactLevel.values[reader.read() as int];
  }

  @override
  void write(BinaryWriter writer, ImpactLevel l) {
    writer.write(l.index);
  }
}

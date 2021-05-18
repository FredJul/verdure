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
    this.packagingImpact,
    this.productionImpact,
    this.transportationImpact,
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
  Grade? ecoscoreGrade;

  @HiveField(7)
  ImpactLevel? packagingImpact;

  @HiveField(8)
  ImpactLevel? productionImpact;

  @HiveField(9)
  ImpactLevel? transportationImpact;

  @HiveField(10)
  Grade? nutriscoreGrade;

  @HiveField(11)
  ImpactLevel? sugarsLevel;

  @HiveField(12)
  ImpactLevel? fatLevel;

  @HiveField(13)
  ImpactLevel? saturatedFatLevel;

  @HiveField(14)
  ImpactLevel? saltLevel;

  @HiveField(15)
  String? quantity;

  @HiveField(16)
  List<String> categoryTags;
}

enum Grade { a, b, c, d, e }

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

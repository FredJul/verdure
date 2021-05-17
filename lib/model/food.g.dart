// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension FoodCopyWith on Food {
  Food copyWith({
    String? barcode,
    String? brands,
    List<String>? categoryTags,
    String? ecoscoreGrade,
    double? ecoscoreScore,
    Level? fatLevel,
    String? imageFrontSmallUrl,
    String? imageFrontUrl,
    String? imageIngredientsUrl,
    String? name,
    String? nutriscoreGrade,
    double? packagingScore,
    double? productionImpactScore,
    String? quantity,
    Level? saltLevel,
    Level? saturatedFatLevel,
    Level? sugarsLevel,
    double? transportationImpactScore,
  }) {
    return Food(
      barcode: barcode ?? this.barcode,
      brands: brands ?? this.brands,
      categoryTags: categoryTags ?? this.categoryTags,
      ecoscoreGrade: ecoscoreGrade ?? this.ecoscoreGrade,
      ecoscoreScore: ecoscoreScore ?? this.ecoscoreScore,
      fatLevel: fatLevel ?? this.fatLevel,
      imageFrontSmallUrl: imageFrontSmallUrl ?? this.imageFrontSmallUrl,
      imageFrontUrl: imageFrontUrl ?? this.imageFrontUrl,
      imageIngredientsUrl: imageIngredientsUrl ?? this.imageIngredientsUrl,
      name: name ?? this.name,
      nutriscoreGrade: nutriscoreGrade ?? this.nutriscoreGrade,
      packagingScore: packagingScore ?? this.packagingScore,
      productionImpactScore:
          productionImpactScore ?? this.productionImpactScore,
      quantity: quantity ?? this.quantity,
      saltLevel: saltLevel ?? this.saltLevel,
      saturatedFatLevel: saturatedFatLevel ?? this.saturatedFatLevel,
      sugarsLevel: sugarsLevel ?? this.sugarsLevel,
      transportationImpactScore:
          transportationImpactScore ?? this.transportationImpactScore,
    );
  }
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodAdapter extends TypeAdapter<Food> {
  @override
  final int typeId = 0;

  @override
  Food read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Food(
      barcode: fields[0] as String,
      name: fields[1] as String,
      brands: fields[2] as String?,
      imageFrontSmallUrl: fields[3] as String?,
      imageFrontUrl: fields[4] as String?,
      imageIngredientsUrl: fields[5] as String?,
      ecoscoreGrade: fields[6] as String?,
      ecoscoreScore: fields[7] as double?,
      packagingScore: fields[8] as double?,
      productionImpactScore: fields[9] as double?,
      transportationImpactScore: fields[10] as double?,
      nutriscoreGrade: fields[11] as String?,
      sugarsLevel: fields[12] as Level,
      fatLevel: fields[13] as Level,
      saturatedFatLevel: fields[14] as Level,
      saltLevel: fields[15] as Level,
      quantity: fields[16] as String?,
      categoryTags: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brands)
      ..writeByte(3)
      ..write(obj.imageFrontSmallUrl)
      ..writeByte(4)
      ..write(obj.imageFrontUrl)
      ..writeByte(5)
      ..write(obj.imageIngredientsUrl)
      ..writeByte(6)
      ..write(obj.ecoscoreGrade)
      ..writeByte(7)
      ..write(obj.ecoscoreScore)
      ..writeByte(8)
      ..write(obj.packagingScore)
      ..writeByte(9)
      ..write(obj.productionImpactScore)
      ..writeByte(10)
      ..write(obj.transportationImpactScore)
      ..writeByte(11)
      ..write(obj.nutriscoreGrade)
      ..writeByte(12)
      ..write(obj.sugarsLevel)
      ..writeByte(13)
      ..write(obj.fatLevel)
      ..writeByte(14)
      ..write(obj.saturatedFatLevel)
      ..writeByte(15)
      ..write(obj.saltLevel)
      ..writeByte(16)
      ..write(obj.quantity)
      ..writeByte(17)
      ..write(obj.categoryTags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

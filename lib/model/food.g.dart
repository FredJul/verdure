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
    Grade? ecoscoreGrade,
    ImpactLevel? fatLevel,
    double? fatQuantity,
    String? imageFrontSmallUrl,
    String? imageFrontUrl,
    String? imageIngredientsUrl,
    double? ingredientsScore,
    bool? missingEcoscoreDataWarning,
    String? name,
    Grade? nutriscoreGrade,
    double? packagingScore,
    String? quantity,
    ImpactLevel? saltLevel,
    double? saltQuantity,
    ImpactLevel? saturatedFatLevel,
    double? saturatedFatQuantity,
    ImpactLevel? sugarsLevel,
    double? sugarsQuantity,
    double? transportationScore,
  }) {
    return Food(
      barcode: barcode ?? this.barcode,
      brands: brands ?? this.brands,
      categoryTags: categoryTags ?? this.categoryTags,
      ecoscoreGrade: ecoscoreGrade ?? this.ecoscoreGrade,
      fatLevel: fatLevel ?? this.fatLevel,
      fatQuantity: fatQuantity ?? this.fatQuantity,
      imageFrontSmallUrl: imageFrontSmallUrl ?? this.imageFrontSmallUrl,
      imageFrontUrl: imageFrontUrl ?? this.imageFrontUrl,
      imageIngredientsUrl: imageIngredientsUrl ?? this.imageIngredientsUrl,
      ingredientsScore: ingredientsScore ?? this.ingredientsScore,
      missingEcoscoreDataWarning:
          missingEcoscoreDataWarning ?? this.missingEcoscoreDataWarning,
      name: name ?? this.name,
      nutriscoreGrade: nutriscoreGrade ?? this.nutriscoreGrade,
      packagingScore: packagingScore ?? this.packagingScore,
      quantity: quantity ?? this.quantity,
      saltLevel: saltLevel ?? this.saltLevel,
      saltQuantity: saltQuantity ?? this.saltQuantity,
      saturatedFatLevel: saturatedFatLevel ?? this.saturatedFatLevel,
      saturatedFatQuantity: saturatedFatQuantity ?? this.saturatedFatQuantity,
      sugarsLevel: sugarsLevel ?? this.sugarsLevel,
      sugarsQuantity: sugarsQuantity ?? this.sugarsQuantity,
      transportationScore: transportationScore ?? this.transportationScore,
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
      ecoscoreGrade: fields[6] as Grade?,
      ingredientsScore: fields[7] as double?,
      packagingScore: fields[8] as double?,
      transportationScore: fields[9] as double?,
      missingEcoscoreDataWarning: fields[10] as bool,
      nutriscoreGrade: fields[11] as Grade?,
      sugarsQuantity: fields[12] as double?,
      fatQuantity: fields[13] as double?,
      saturatedFatQuantity: fields[14] as double?,
      saltQuantity: fields[15] as double?,
      sugarsLevel: fields[16] as ImpactLevel?,
      fatLevel: fields[17] as ImpactLevel?,
      saturatedFatLevel: fields[18] as ImpactLevel?,
      saltLevel: fields[19] as ImpactLevel?,
      quantity: fields[20] as String?,
      categoryTags: (fields[21] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(22)
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
      ..write(obj.ingredientsScore)
      ..writeByte(8)
      ..write(obj.packagingScore)
      ..writeByte(9)
      ..write(obj.transportationScore)
      ..writeByte(10)
      ..write(obj.missingEcoscoreDataWarning)
      ..writeByte(11)
      ..write(obj.nutriscoreGrade)
      ..writeByte(12)
      ..write(obj.sugarsQuantity)
      ..writeByte(13)
      ..write(obj.fatQuantity)
      ..writeByte(14)
      ..write(obj.saturatedFatQuantity)
      ..writeByte(15)
      ..write(obj.saltQuantity)
      ..writeByte(16)
      ..write(obj.sugarsLevel)
      ..writeByte(17)
      ..write(obj.fatLevel)
      ..writeByte(18)
      ..write(obj.saturatedFatLevel)
      ..writeByte(19)
      ..write(obj.saltLevel)
      ..writeByte(20)
      ..write(obj.quantity)
      ..writeByte(21)
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

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
    String? imageFrontSmallUrl,
    String? imageFrontUrl,
    String? imageIngredientsUrl,
    String? name,
    Grade? nutriscoreGrade,
    ImpactLevel? packagingImpact,
    ImpactLevel? productionImpact,
    String? quantity,
    ImpactLevel? saltLevel,
    ImpactLevel? saturatedFatLevel,
    ImpactLevel? sugarsLevel,
    ImpactLevel? transportationImpact,
  }) {
    return Food(
      barcode: barcode ?? this.barcode,
      brands: brands ?? this.brands,
      categoryTags: categoryTags ?? this.categoryTags,
      ecoscoreGrade: ecoscoreGrade ?? this.ecoscoreGrade,
      fatLevel: fatLevel ?? this.fatLevel,
      imageFrontSmallUrl: imageFrontSmallUrl ?? this.imageFrontSmallUrl,
      imageFrontUrl: imageFrontUrl ?? this.imageFrontUrl,
      imageIngredientsUrl: imageIngredientsUrl ?? this.imageIngredientsUrl,
      name: name ?? this.name,
      nutriscoreGrade: nutriscoreGrade ?? this.nutriscoreGrade,
      packagingImpact: packagingImpact ?? this.packagingImpact,
      productionImpact: productionImpact ?? this.productionImpact,
      quantity: quantity ?? this.quantity,
      saltLevel: saltLevel ?? this.saltLevel,
      saturatedFatLevel: saturatedFatLevel ?? this.saturatedFatLevel,
      sugarsLevel: sugarsLevel ?? this.sugarsLevel,
      transportationImpact: transportationImpact ?? this.transportationImpact,
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
      packagingImpact: fields[7] as ImpactLevel?,
      productionImpact: fields[8] as ImpactLevel?,
      transportationImpact: fields[9] as ImpactLevel?,
      nutriscoreGrade: fields[10] as Grade?,
      sugarsLevel: fields[11] as ImpactLevel?,
      fatLevel: fields[12] as ImpactLevel?,
      saturatedFatLevel: fields[13] as ImpactLevel?,
      saltLevel: fields[14] as ImpactLevel?,
      quantity: fields[15] as String?,
      categoryTags: (fields[16] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(17)
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
      ..write(obj.packagingImpact)
      ..writeByte(8)
      ..write(obj.productionImpact)
      ..writeByte(9)
      ..write(obj.transportationImpact)
      ..writeByte(10)
      ..write(obj.nutriscoreGrade)
      ..writeByte(11)
      ..write(obj.sugarsLevel)
      ..writeByte(12)
      ..write(obj.fatLevel)
      ..writeByte(13)
      ..write(obj.saturatedFatLevel)
      ..writeByte(14)
      ..write(obj.saltLevel)
      ..writeByte(15)
      ..write(obj.quantity)
      ..writeByte(16)
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

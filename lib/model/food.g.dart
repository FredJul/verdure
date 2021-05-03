// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

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
      nutriscoreGrade: fields[8] as String?,
      quantity: fields[9] as String?,
      categoryTags: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.nutriscoreGrade)
      ..writeByte(9)
      ..write(obj.quantity)
      ..writeByte(10)
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

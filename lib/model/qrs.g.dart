// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QrsAdapter extends TypeAdapter<Qrs> {
  @override
  final int typeId = 0;

  @override
  Qrs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Qrs()
      ..name = fields[0] as String
      ..url = fields[1] as String
      ..imageUrl = fields[2] as String
      ..randomColor = fields[3] as String
      ..category = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Qrs obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.randomColor)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

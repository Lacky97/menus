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
    return Qrs()..name = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, Qrs obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
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
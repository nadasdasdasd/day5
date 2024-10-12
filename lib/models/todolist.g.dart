// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodolistAdapter extends TypeAdapter<Todolist> {
  @override
  final int typeId = 0;

  @override
  Todolist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todolist(
      task: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Todolist obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.task);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodolistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

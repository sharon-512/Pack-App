// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      email: fields[1] as String?,
      firstname: fields[2] as String?,
      lastname: fields[3] as String?,
      image: fields[4] as String?,
      mobno: fields[5] as String?,
      address: fields[6] as String?,
      areaName: fields[7] as String?,
      height: fields[8] as String?,
      weight: fields[9] as String?,
      age: fields[10] as String?,
      gender: fields[11] as String?,
      addresline: fields[12] as String?,
      street: fields[13] as String?,
      floor: fields[14] as String?,
      flat: fields[15] as String?,
      foodavoid: fields[16] as String?,
      activitylevel: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.lastname)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.mobno)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.areaName)
      ..writeByte(8)
      ..write(obj.height)
      ..writeByte(9)
      ..write(obj.weight)
      ..writeByte(10)
      ..write(obj.age)
      ..writeByte(11)
      ..write(obj.gender)
      ..writeByte(12)
      ..write(obj.addresline)
      ..writeByte(13)
      ..write(obj.street)
      ..writeByte(14)
      ..write(obj.floor)
      ..writeByte(15)
      ..write(obj.flat)
      ..writeByte(16)
      ..write(obj.foodavoid)
      ..writeByte(17)
      ..write(obj.activitylevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

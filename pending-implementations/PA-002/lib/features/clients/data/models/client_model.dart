import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    super.id,
    required super.nombre,
    required super.apellidos,
    required super.telefono,
    super.email,
    super.dniNie,
    super.direccion,
    super.notas,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      apellidos: map['apellidos'] as String,
      telefono: map['telefono'] as String,
      email: map['email'] as String?,
      dniNie: map['dni_nie'] as String?,
      direccion: map['direccion'] as String?,
      notas: map['notas'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'telefono': telefono,
      'email': email,
      'dni_nie': dniNie,
      'direccion': direccion,
      'notas': notas,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      nombre: client.nombre,
      apellidos: client.apellidos,
      telefono: client.telefono,
      email: client.email,
      dniNie: client.dniNie,
      direccion: client.direccion,
      notas: client.notas,
      createdAt: client.createdAt,
      updatedAt: client.updatedAt,
    );
  }
}

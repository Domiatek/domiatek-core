import 'package:equatable/equatable.dart';

class Client extends Equatable {
  const Client({
    this.id,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    this.email,
    this.dniNie,
    this.direccion,
    this.notas,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String nombre;
  final String apellidos;
  final String telefono;
  final String? email;
  final String? dniNie;
  final String? direccion;
  final String? notas;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get nombreCompleto => '$nombre $apellidos'.trim();

  Client copyWith({
    int? id,
    String? nombre,
    String? apellidos,
    String? telefono,
    String? email,
    String? dniNie,
    String? direccion,
    String? notas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      dniNie: dniNie ?? this.dniNie,
      direccion: direccion ?? this.direccion,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        apellidos,
        telefono,
        email,
        dniNie,
        direccion,
        notas,
        createdAt,
        updatedAt,
      ];
}

part of 'client_form_bloc.dart';

abstract class ClientFormEvent extends Equatable {
  const ClientFormEvent();

  @override
  List<Object?> get props => [];
}

class ClientFormLoaded extends ClientFormEvent {
  const ClientFormLoaded(this.clientId);

  final int? clientId;

  @override
  List<Object?> get props => [clientId];
}

class ClientFormSaveRequested extends ClientFormEvent {
  const ClientFormSaveRequested({
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    this.email,
    this.dniNie,
    this.direccion,
    this.notas,
  });

  final String nombre;
  final String apellidos;
  final String telefono;
  final String? email;
  final String? dniNie;
  final String? direccion;
  final String? notas;

  @override
  List<Object?> get props =>
      [nombre, apellidos, telefono, email, dniNie, direccion, notas];
}

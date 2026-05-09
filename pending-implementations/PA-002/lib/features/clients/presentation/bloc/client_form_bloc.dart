import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/client.dart';
import '../../domain/usecases/create_client.dart';
import '../../domain/usecases/get_client_by_id.dart';
import '../../domain/usecases/update_client.dart';

part 'client_form_event.dart';
part 'client_form_state.dart';

class ClientFormBloc extends Bloc<ClientFormEvent, ClientFormState> {
  ClientFormBloc({
    required GetClientById getClientById,
    required CreateClient createClient,
    required UpdateClient updateClient,
  })  : _getClientById = getClientById,
        _createClient = createClient,
        _updateClient = updateClient,
        super(const ClientFormInitial()) {
    on<ClientFormLoaded>(_onLoaded);
    on<ClientFormSaveRequested>(_onSave);
  }

  final GetClientById _getClientById;
  final CreateClient _createClient;
  final UpdateClient _updateClient;

  Future<void> _onLoaded(
    ClientFormLoaded event,
    Emitter<ClientFormState> emit,
  ) async {
    if (event.clientId == null) {
      emit(const ClientFormReady());
      return;
    }
    emit(const ClientFormLoading());
    final result = await _getClientById(GetClientByIdParams(id: event.clientId!));
    result.fold(
      (failure) => emit(ClientFormError(failure.message)),
      (client) => emit(ClientFormReady(client: client)),
    );
  }

  Future<void> _onSave(
    ClientFormSaveRequested event,
    Emitter<ClientFormState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ClientFormReady) return;

    emit(const ClientFormSaving());

    final now = DateTime.now();
    final client = Client(
      id: currentState.client?.id,
      nombre: event.nombre.trim(),
      apellidos: event.apellidos.trim(),
      telefono: event.telefono.trim(),
      email: event.email?.trim().isEmpty == true ? null : event.email?.trim(),
      dniNie: event.dniNie?.trim().isEmpty == true ? null : event.dniNie?.trim(),
      direccion:
          event.direccion?.trim().isEmpty == true ? null : event.direccion?.trim(),
      notas: event.notas?.trim().isEmpty == true ? null : event.notas?.trim(),
      createdAt: currentState.client?.createdAt ?? now,
      updatedAt: now,
    );

    final result = currentState.isEditing
        ? await _updateClient(UpdateClientParams(client: client))
        : await _createClient(CreateClientParams(client: client));

    result.fold(
      (failure) => emit(ClientFormError(failure.message)),
      (saved) => emit(ClientFormSuccess(saved)),
    );
  }
}

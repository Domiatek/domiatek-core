import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/client.dart';
import '../../domain/usecases/delete_client.dart';
import '../../domain/usecases/get_all_clients.dart';
import '../../domain/usecases/search_clients.dart';
import '../../../../core/usecases/usecase.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  ClientsBloc({
    required GetAllClients getAllClients,
    required SearchClients searchClients,
    required DeleteClient deleteClient,
  })  : _getAllClients = getAllClients,
        _searchClients = searchClients,
        _deleteClient = deleteClient,
        super(const ClientsInitial()) {
    on<ClientsLoadRequested>(_onLoad);
    on<ClientsSearchChanged>(_onSearchChanged, transformer: _debounce());
    on<ClientsSearchCleared>(_onSearchCleared);
    on<ClientDeleteRequested>(_onDelete);
  }

  final GetAllClients _getAllClients;
  final SearchClients _searchClients;
  final DeleteClient _deleteClient;

  EventTransformer<ClientsSearchChanged> _debounce<ClientsSearchChanged>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 350))
        .asyncExpand(mapper);
  }

  Future<void> _onLoad(
    ClientsLoadRequested event,
    Emitter<ClientsState> emit,
  ) async {
    emit(const ClientsLoading());
    final result = await _getAllClients(const NoParams());
    result.fold(
      (failure) => emit(ClientsError(failure.message)),
      (clients) => emit(ClientsLoaded(clients: clients)),
    );
  }

  Future<void> _onSearchChanged(
    ClientsSearchChanged event,
    Emitter<ClientsState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const ClientsSearchCleared());
      return;
    }
    emit(const ClientsLoading());
    final result = await _searchClients(SearchClientsParams(query: event.query));
    result.fold(
      (failure) => emit(ClientsError(failure.message)),
      (clients) => emit(ClientsLoaded(clients: clients, searchQuery: event.query)),
    );
  }

  Future<void> _onSearchCleared(
    ClientsSearchCleared event,
    Emitter<ClientsState> emit,
  ) async {
    add(const ClientsLoadRequested());
  }

  Future<void> _onDelete(
    ClientDeleteRequested event,
    Emitter<ClientsState> emit,
  ) async {
    final result = await _deleteClient(DeleteClientParams(id: event.id));
    result.fold(
      (failure) => emit(ClientsError(failure.message)),
      (_) {
        emit(ClientDeleteSuccess(event.id));
        add(const ClientsLoadRequested());
      },
    );
  }
}

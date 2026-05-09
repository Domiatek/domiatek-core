part of 'clients_bloc.dart';

abstract class ClientsState extends Equatable {
  const ClientsState();

  @override
  List<Object?> get props => [];
}

class ClientsInitial extends ClientsState {
  const ClientsInitial();
}

class ClientsLoading extends ClientsState {
  const ClientsLoading();
}

class ClientsLoaded extends ClientsState {
  const ClientsLoaded({
    required this.clients,
    this.searchQuery = '',
  });

  final List<Client> clients;
  final String searchQuery;

  bool get isSearching => searchQuery.isNotEmpty;

  @override
  List<Object> get props => [clients, searchQuery];
}

class ClientsError extends ClientsState {
  const ClientsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ClientDeleteSuccess extends ClientsState {
  const ClientDeleteSuccess(this.deletedId);

  final int deletedId;

  @override
  List<Object> get props => [deletedId];
}

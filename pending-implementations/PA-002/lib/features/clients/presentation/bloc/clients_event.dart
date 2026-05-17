part of 'clients_bloc.dart';

abstract class ClientsEvent extends Equatable {
  const ClientsEvent();

  @override
  List<Object?> get props => [];
}

class ClientsLoadRequested extends ClientsEvent {
  const ClientsLoadRequested();
}

class ClientsSearchChanged extends ClientsEvent {
  const ClientsSearchChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class ClientsSearchCleared extends ClientsEvent {
  const ClientsSearchCleared();
}

class ClientDeleteRequested extends ClientsEvent {
  const ClientDeleteRequested(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

part of 'client_form_bloc.dart';

abstract class ClientFormState extends Equatable {
  const ClientFormState();

  @override
  List<Object?> get props => [];
}

class ClientFormInitial extends ClientFormState {
  const ClientFormInitial();
}

class ClientFormLoading extends ClientFormState {
  const ClientFormLoading();
}

class ClientFormReady extends ClientFormState {
  const ClientFormReady({this.client});

  final Client? client;

  bool get isEditing => client != null;

  @override
  List<Object?> get props => [client];
}

class ClientFormSaving extends ClientFormState {
  const ClientFormSaving();
}

class ClientFormSuccess extends ClientFormState {
  const ClientFormSuccess(this.client);

  final Client client;

  @override
  List<Object> get props => [client];
}

class ClientFormError extends ClientFormState {
  const ClientFormError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

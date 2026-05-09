import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class CreateClient implements UseCase<Client, CreateClientParams> {
  CreateClient(this._repository);

  final ClientRepository _repository;

  @override
  Future<Either<Failure, Client>> call(CreateClientParams params) =>
      _repository.createClient(params.client);
}

class CreateClientParams extends Equatable {
  const CreateClientParams({required this.client});

  final Client client;

  @override
  List<Object> get props => [client];
}

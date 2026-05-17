import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class UpdateClient implements UseCase<Client, UpdateClientParams> {
  UpdateClient(this._repository);

  final ClientRepository _repository;

  @override
  Future<Either<Failure, Client>> call(UpdateClientParams params) =>
      _repository.updateClient(params.client);
}

class UpdateClientParams extends Equatable {
  const UpdateClientParams({required this.client});

  final Client client;

  @override
  List<Object> get props => [client];
}

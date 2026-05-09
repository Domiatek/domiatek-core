import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class GetClientById implements UseCase<Client, GetClientByIdParams> {
  GetClientById(this._repository);

  final ClientRepository _repository;

  @override
  Future<Either<Failure, Client>> call(GetClientByIdParams params) =>
      _repository.getClientById(params.id);
}

class GetClientByIdParams extends Equatable {
  const GetClientByIdParams({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}

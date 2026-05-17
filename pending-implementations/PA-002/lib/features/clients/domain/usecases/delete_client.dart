import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/client_repository.dart';

class DeleteClient implements UseCase<Unit, DeleteClientParams> {
  DeleteClient(this._repository);

  final ClientRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteClientParams params) =>
      _repository.deleteClient(params.id);
}

class DeleteClientParams extends Equatable {
  const DeleteClientParams({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}

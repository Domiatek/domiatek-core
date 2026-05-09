import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class GetAllClients implements UseCase<List<Client>, NoParams> {
  GetAllClients(this._repository);

  final ClientRepository _repository;

  @override
  Future<Either<Failure, List<Client>>> call(NoParams params) =>
      _repository.getAllClients();
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class SearchClients implements UseCase<List<Client>, SearchClientsParams> {
  SearchClients(this._repository);

  final ClientRepository _repository;

  @override
  Future<Either<Failure, List<Client>>> call(SearchClientsParams params) =>
      _repository.searchClients(params.query);
}

class SearchClientsParams extends Equatable {
  const SearchClientsParams({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}

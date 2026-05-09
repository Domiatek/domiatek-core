import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_local_datasource.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl(this._datasource);

  final ClientLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<Client>>> getAllClients() async {
    try {
      return Right(await _datasource.getAllClients());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Client>> getClientById(int id) async {
    try {
      return Right(await _datasource.getClientById(id));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> searchClients(String query) async {
    try {
      return Right(await _datasource.searchClients(query));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Client>> createClient(Client client) async {
    try {
      final now = DateTime.now();
      final model = ClientModel.fromEntity(
        client.copyWith(createdAt: now, updatedAt: now),
      );
      return Right(await _datasource.createClient(model));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    try {
      final model = ClientModel.fromEntity(
        client.copyWith(updatedAt: DateTime.now()),
      );
      return Right(await _datasource.updateClient(model));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteClient(int id) async {
    try {
      await _datasource.deleteClient(id);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

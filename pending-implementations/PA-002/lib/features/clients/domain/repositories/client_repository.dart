import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getAllClients();
  Future<Either<Failure, Client>> getClientById(int id);
  Future<Either<Failure, List<Client>>> searchClients(String query);
  Future<Either<Failure, Client>> createClient(Client client);
  Future<Either<Failure, Client>> updateClient(Client client);
  Future<Either<Failure, Unit>> deleteClient(int id);
}

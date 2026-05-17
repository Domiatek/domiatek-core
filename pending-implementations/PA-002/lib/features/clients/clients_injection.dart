import 'package:get_it/get_it.dart';

import 'data/datasources/client_local_datasource.dart';
import 'data/repositories/client_repository_impl.dart';
import 'domain/repositories/client_repository.dart';
import 'domain/usecases/create_client.dart';
import 'domain/usecases/delete_client.dart';
import 'domain/usecases/get_all_clients.dart';
import 'domain/usecases/get_client_by_id.dart';
import 'domain/usecases/search_clients.dart';
import 'domain/usecases/update_client.dart';
import 'presentation/bloc/client_form_bloc.dart';
import 'presentation/bloc/clients_bloc.dart';

void registerClientsFeature(GetIt sl) {
  // datasource
  sl.registerLazySingleton<ClientLocalDatasource>(
    () => ClientLocalDatasourceImpl(sl()),
  );

  // repository
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(sl()),
  );

  // usecases
  sl.registerLazySingleton(() => GetAllClients(sl()));
  sl.registerLazySingleton(() => GetClientById(sl()));
  sl.registerLazySingleton(() => SearchClients(sl()));
  sl.registerLazySingleton(() => CreateClient(sl()));
  sl.registerLazySingleton(() => UpdateClient(sl()));
  sl.registerLazySingleton(() => DeleteClient(sl()));

  // blocs — registered as factory so each page gets a fresh instance
  sl.registerFactory(
    () => ClientsBloc(
      getAllClients: sl(),
      searchClients: sl(),
      deleteClient: sl(),
    ),
  );
  sl.registerFactory(
    () => ClientFormBloc(
      getClientById: sl(),
      createClient: sl(),
      updateClient: sl(),
    ),
  );
}

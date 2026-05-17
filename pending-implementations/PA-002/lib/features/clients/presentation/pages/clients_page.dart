import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/clients_bloc.dart';
import '../widgets/client_list_tile.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ClientsBloc>().add(const ClientsLoadRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Buscar por nombre, teléfono, DNI…',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context
                          .read<ClientsBloc>()
                          .add(const ClientsSearchCleared());
                    },
                  ),
              ],
              onChanged: (q) {
                context
                    .read<ClientsBloc>()
                    .add(ClientsSearchChanged(q));
              },
            ),
          ),
        ),
      ),
      body: BlocConsumer<ClientsBloc, ClientsState>(
        listener: (context, state) {
          if (state is ClientsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state is ClientDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente eliminado')),
            );
          }
        },
        builder: (context, state) {
          if (state is ClientsLoading || state is ClientsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClientsLoaded) {
            if (state.clients.isEmpty) {
              return _EmptyState(isSearching: state.isSearching);
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<ClientsBloc>().add(const ClientsLoadRequested()),
              child: ListView.separated(
                itemCount: state.clients.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final client = state.clients[index];
                  return ClientListTile(
                    client: client,
                    onTap: () => context.push('/clients/${client.id}'),
                    onDelete: () => context
                        .read<ClientsBloc>()
                        .add(ClientDeleteRequested(client.id!)),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/clients/new');
          if (context.mounted) {
            context.read<ClientsBloc>().add(const ClientsLoadRequested());
          }
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo cliente'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Sin resultados' : 'No hay clientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Prueba con otro término de búsqueda.'
                  : 'Añade tu primer cliente pulsando el botón.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

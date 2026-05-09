import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/clients_bloc.dart';
import '../bloc/client_form_bloc.dart';
import '../widgets/client_history_section.dart';

class ClientDetailPage extends StatefulWidget {
  const ClientDetailPage({super.key, required this.clientId});

  final int clientId;

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context
        .read<ClientFormBloc>()
        .add(ClientFormLoaded(widget.clientId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientFormBloc, ClientFormState>(
      listener: (context, state) {
        if (state is ClientFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ClientFormLoading || state is ClientFormInitial) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is! ClientFormReady || state.client == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cliente')),
            body: const Center(child: Text('Cliente no encontrado')),
          );
        }
        final client = state.client!;
        return Scaffold(
          appBar: AppBar(
            title: Text(client.nombreCompleto),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar',
                onPressed: () async {
                  await context.push('/clients/${widget.clientId}/edit');
                  if (context.mounted) {
                    context
                        .read<ClientFormBloc>()
                        .add(ClientFormLoaded(widget.clientId));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Eliminar',
                onPressed: () => _confirmDelete(context, client.id!),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'Ficha'),
                Tab(icon: Icon(Icons.history), text: 'Historial'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _ClientInfoTab(client: client),
              ClientHistorySection(clientId: widget.clientId),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: const Text(
          '¿Estás seguro? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ClientsBloc>().add(ClientDeleteRequested(id));
      context.pop();
    }
  }
}

class _ClientInfoTab extends StatelessWidget {
  const _ClientInfoTab({required this.client});

  final client;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoTile(
          icon: Icons.phone,
          label: 'Teléfono',
          value: client.telefono,
        ),
        if (client.email != null)
          _InfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: client.email!,
          ),
        if (client.dniNie != null)
          _InfoTile(
            icon: Icons.badge_outlined,
            label: 'DNI / NIE',
            value: client.dniNie!,
          ),
        if (client.direccion != null)
          _InfoTile(
            icon: Icons.location_on_outlined,
            label: 'Dirección',
            value: client.direccion!,
          ),
        if (client.notas != null) ...[
          const Divider(height: 32),
          Text('Notas', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(client.notas!),
        ],
        const Divider(height: 32),
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          label: 'Cliente desde',
          value: df.format(client.createdAt),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.labelSmall),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

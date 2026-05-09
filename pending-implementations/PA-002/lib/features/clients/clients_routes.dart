import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'presentation/bloc/client_form_bloc.dart';
import 'presentation/bloc/clients_bloc.dart';
import 'presentation/pages/client_detail_page.dart';
import 'presentation/pages/client_form_page.dart';
import 'presentation/pages/clients_page.dart';

/// Merge these routes into the app's main GoRouter configuration.
final clientsRoutes = <RouteBase>[
  GoRoute(
    path: '/clients',
    builder: (context, state) => BlocProvider(
      create: (_) => GetIt.instance<ClientsBloc>(),
      child: const ClientsPage(),
    ),
    routes: [
      GoRoute(
        path: 'new',
        builder: (context, state) => BlocProvider(
          create: (_) => GetIt.instance<ClientFormBloc>(),
          child: const ClientFormPage(),
        ),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => GetIt.instance<ClientsBloc>()),
              BlocProvider(create: (_) => GetIt.instance<ClientFormBloc>()),
            ],
            child: ClientDetailPage(clientId: id),
          );
        },
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (_) => GetIt.instance<ClientFormBloc>(),
                child: ClientFormPage(clientId: id),
              );
            },
          ),
        ],
      ),
    ],
  ),
];

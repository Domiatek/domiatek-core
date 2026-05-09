# PA-002 Integration Guide

## Files to add to proges-app

Place everything under `lib/features/clients/` and `lib/core/database/migrations/`.

## pubspec.yaml dependencies (ensure present)

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  equatable: ^2.0.5
  dartz: ^0.10.1
  get_it: ^7.7.0
  sqflite: ^2.3.3
  go_router: ^14.0.0
  intl: ^0.19.0
```

## Database migration

In `DatabaseHelper`, bump `_kVersion` to `2` and add to `onUpgrade`:

```dart
if (oldVersion < 2) {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS clients (
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre     TEXT    NOT NULL,
      apellidos  TEXT    NOT NULL,
      telefono   TEXT    NOT NULL,
      email      TEXT,
      dni_nie    TEXT,
      direccion  TEXT,
      notas      TEXT,
      created_at TEXT    NOT NULL,
      updated_at TEXT    NOT NULL
    )
  ''');
  await db.execute('CREATE INDEX IF NOT EXISTS idx_clients_apellidos ON clients (apellidos)');
  await db.execute('CREATE INDEX IF NOT EXISTS idx_clients_telefono  ON clients (telefono)');
}
```

## Injection

Call `registerClientsFeature(sl)` in your `injection_container.dart` after registering `DatabaseHelper`.

## Router

Merge `clientsRoutes` into your root `GoRouter`:

```dart
GoRouter(
  routes: [
    ...clientsRoutes,
    // other routes
  ],
)
```

## Bottom nav

Add a "Clientes" tab with `Icons.people` pointing to `/clients`.

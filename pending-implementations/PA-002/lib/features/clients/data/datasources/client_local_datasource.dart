import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/client_model.dart';

abstract class ClientLocalDatasource {
  Future<List<ClientModel>> getAllClients();
  Future<ClientModel> getClientById(int id);
  Future<List<ClientModel>> searchClients(String query);
  Future<ClientModel> createClient(ClientModel client);
  Future<ClientModel> updateClient(ClientModel client);
  Future<void> deleteClient(int id);
}

class ClientLocalDatasourceImpl implements ClientLocalDatasource {
  ClientLocalDatasourceImpl(this._dbHelper);

  final DatabaseHelper _dbHelper;

  static const _table = 'clients';

  @override
  Future<List<ClientModel>> getAllClients() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      _table,
      orderBy: 'apellidos ASC, nombre ASC',
    );
    return maps.map(ClientModel.fromMap).toList();
  }

  @override
  Future<ClientModel> getClientById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) throw const CacheException('Cliente no encontrado');
    return ClientModel.fromMap(maps.first);
  }

  @override
  Future<List<ClientModel>> searchClients(String query) async {
    final db = await _dbHelper.database;
    final q = '%${query.toLowerCase()}%';
    final maps = await db.rawQuery(
      '''
      SELECT * FROM $_table
      WHERE LOWER(nombre) LIKE ?
         OR LOWER(apellidos) LIKE ?
         OR LOWER(telefono) LIKE ?
         OR LOWER(COALESCE(dni_nie, '')) LIKE ?
         OR LOWER(COALESCE(email, '')) LIKE ?
      ORDER BY apellidos ASC, nombre ASC
      ''',
      [q, q, q, q, q],
    );
    return maps.map(ClientModel.fromMap).toList();
  }

  @override
  Future<ClientModel> createClient(ClientModel client) async {
    final db = await _dbHelper.database;
    final map = client.toMap()..remove('id');
    final id = await db.insert(
      _table,
      map,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return client.copyWith(id: id) as ClientModel;
  }

  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    final db = await _dbHelper.database;
    final count = await db.update(
      _table,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
    if (count == 0) throw const CacheException('Cliente no encontrado');
    return client;
  }

  @override
  Future<void> deleteClient(int id) async {
    final db = await _dbHelper.database;
    final count = await db.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (count == 0) throw const CacheException('Cliente no encontrado');
  }
}

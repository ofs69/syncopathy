import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/repository/db_entity.dart';

abstract class Repository<TKey, T extends DbEntity<TKey>> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final String tableName;
  final Map<TKey, T> _identityMap = {};

  Repository(this.tableName);
  T mapToEntity(Map<String, dynamic> map);

  Future<List<T>> getAll() async {
    final db = await dbHelper.database;
    final entityMaps = await db.query(tableName);
    if (entityMaps.isEmpty) {
      return [];
    }
    final entities = entityMaps.map((map) => mapToEntity(map)).toList();

    final entityIdentities = <T>[];
    for (final entity in entities) {
      final entityIdentity = _identityMap.putIfAbsent(
        entity.id as TKey,
        () => entity,
      );
      entityIdentities.add(entityIdentity);
    }
    return entityIdentities;
  }

  Future<T?> getById(TKey? id) async {
    if (id == null) return null;
    if (_identityMap.containsKey(id)) {
      final obj = _identityMap[id];
      return obj;
    }

    final db = await dbHelper.database;
    final results = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (results.isEmpty) return null;

    final entity = mapToEntity(results.first);
    final mapped = _identityMap.putIfAbsent(id, () => entity);
    return mapped;
  }

  Future<T?> save(T entity) async {
    final map = entity.toMap();
    final db = await dbHelper.database;

    // If doesn't have an id insert. Otherwise update
    if (entity.id == null) {
      final id = await db.insert(
        tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (id case TKey key) {
        entity.id = key;
      }
    } else {
      await db.update(
        tableName,
        map,
        where: 'id = ?',
        whereArgs: [entity.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final cachedRef = _identityMap[entity.id];
    final cachedObj = cachedRef;

    if (cachedObj != null && !identical(cachedObj, entity)) {
      cachedObj.updateFromMap(map);
      return cachedObj;
    } else if (cachedObj == null) {
      final mapped = _identityMap.putIfAbsent(entity.id as TKey, () => entity);
      return mapped;
    }
    return cachedObj;
  }

  Future<int> delete(TKey id) async {
    final db = await dbHelper.database;
    final deletedRows = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedRows >= 1) {
      _identityMap.remove(id);
    }
    return deletedRows;
  }

  Future<int> saveAll(List<T> entities) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (final entity in entities) {
      // If doesn't have an id insert. Otherwise update
      if (entity.id == null) {
        batch.insert(
          tableName,
          entity.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        batch.update(
          tableName,
          entity.toMap(),
          where: 'id = ?',
          whereArgs: [entity.id],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    final result = await batch.commit();
    return result.length;
  }
}
